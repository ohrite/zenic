defmodule Zenic.Rect do
  alias Zenic.Math.Vector3
  alias Zenic.{Transform, Camera}

  @default {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
  defstruct points: @default, options: [], transform: Transform.new()

  @type t :: %__MODULE__{
          points: {Vector3.t(), Vector3.t(), Vector3.t(), Vector3.t()},
          options: keyword,
          transform: Transform.t()
        }

  @spec new(width :: number, height :: number, options :: keyword) :: t()
  def new(width, height, options \\ [])

  def new(width, height, options) do
    {transform, options} = Keyword.pop(options, :transform, Transform.new())

    with x = width / 2,
         y = height / 2,
         points = {{-x, -y, 0}, {x, -y, 0}, {x, y, 0}, {-x, y, 0}} do
      %__MODULE__{points: points, options: options, transform: transform}
    end
  end

  defimpl Zenic.Renderable, for: __MODULE__ do
    defp hidden?(point1, point2, point3, %{position: position}) do
      normal =
        Vector3.sub(point1, point2)
        |> Vector3.cross(Vector3.sub(point1, point3))
        |> Vector3.normalize()

      Vector3.dot(normal, Vector3.sub(point1, position)) >= 0
    end

    defp to_opts([p1, p2, p3, _], {_, _, z}, camera, options) do
      {backface, options} = Keyword.pop(options, :backface, false)
      Keyword.merge([hidden: z < 0 || !(backface || hidden?(p1, p2, p3, camera))], options)
    end

    def to_specs(%{points: points, options: options, transform: transform}, camera, transforms) do
      [center | transformed] =
        [{0, 0, 0} | Tuple.to_list(points)]
        |> Transform.project([transform | transforms])

      points =
        transformed
        |> Camera.project(camera)
        |> Enum.map(fn {x, y, _} -> {x, y} end)
        |> List.to_tuple()

      [{center, Scenic.Primitive.Quad, points, to_opts(transformed, center, camera, options)}]
    end
  end
end
