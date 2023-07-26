defmodule Zenic.Ellipse do
  alias Zenic.Math.Vector3
  alias Zenic.{Transform, Camera}
  alias Scenic.Math.Vector2

  @default [
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0}
  ]
  defstruct points: @default, quarters: 4, options: [], transform: Transform.new()

  @type t :: %__MODULE__{
          points: list(Vector3.t()),
          quarters: number,
          options: keyword,
          transform: Transform.t()
        }

  @spec new(width :: number, height :: number, options :: keyword) :: t()
  def new(width, height, options \\ [])

  def new(width, height, options) do
    {transform, options} = Keyword.pop(options, :transform, Transform.new())
    {quarters, options} = Keyword.pop(options, :quarters, 4)
    x = width / 2
    y = height / 2

    points =
      Enum.reduce(1..quarters, [{0, -y, 0}], fn quarter, points ->
        case quarter do
          1 -> [{x, 0, 0}, {x, -y, 0} | points]
          2 -> [{0, y, 0}, {x, y, 0} | points]
          3 -> [{-x, 0, 0}, {-x, y, 0} | points]
          4 -> [{0, -y, 0}, {-x, -y, 0} | points]
        end
      end)

    %__MODULE__{
      points: Enum.reverse(points),
      quarters: quarters,
      options: options,
      transform: transform
    }
  end

  defimpl Zenic.Renderable, for: __MODULE__ do
    # Approximate a circle with a cubic Bézier https://spencermortensen.com/articles/bezier-circle/
    @mortensens 0.5519150244935105707435627

    defp hidden?(point1, point2, point3, %{position: position}) do
      normal =
        Vector3.sub(point1, point2)
        |> Vector3.cross(Vector3.sub(point1, point3))
        |> Vector3.normalize()

      Vector3.dot(normal, Vector3.sub(point1, position)) >= 0
    end

    defp to_opts([p1, p2, p3 | _], {_, _, z}, camera, options) do
      {backface, options} = Keyword.pop(options, :backface, false)
      Keyword.merge([hidden: z < 0 || !(backface || hidden?(p1, p2, p3, camera))], options)
    end

    defp to_arc([]), do: [:close_path]
    defp to_arc([_]), do: to_arc([])

    defp to_arc([{x0, y0}, {x1, y1}, {x2, y2} | points]) do
      {cx1, cy1} = {x0, y0} |> Vector2.lerp({x1, y1}, @mortensens)
      {cx2, cy2} = {x1, y1} |> Vector2.lerp({x2, y2}, @mortensens)
      [{:bezier_to, cx1, cy1, cx2, cy2, x2, y2} | to_arc([{x2, y2} | points])]
    end

    defp to_path([{x1, y1} | points]),
      do: [:begin, {:move_to, x1, y1} | to_arc([{x1, y1} | points])]

    def to_specs(%{points: points, options: options, transform: transform}, camera, transforms) do
      [center | transformed] =
        [{0, 0, 0} | points]
        |> Transform.project([transform | transforms])

      points =
        transformed
        |> Camera.project(camera)
        |> Enum.map(fn {x, y, _} -> {x, y} end)

      [
        {center, Scenic.Primitive.Path, to_path(points),
         to_opts(transformed, center, camera, options)}
      ]
    end
  end
end
