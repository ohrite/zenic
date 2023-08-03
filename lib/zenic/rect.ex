defmodule Zenic.Rect do
  alias Zenic.{Camera, Math.Vector3, Transform}

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
    {transform, options} = Transform.pop(options)

    with x = width / 2,
         y = height / 2,
         points = {{-x, -y, 0}, {x, -y, 0}, {x, y, 0}, {-x, y, 0}} do
      %__MODULE__{points: points, options: options, transform: transform}
    end
  end

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.{Camera, Math.Vector3, Transform}

    def apply(%{transform: from, options: options} = rect, %{transforms: transforms}) do
      transform =
        with {:ok, id} <- Keyword.fetch(options, :id),
             {:ok, to} <- Keyword.fetch(transforms, id) do
          Transform.lerp(from, to, 1)
        else
          _ -> from
        end

      %{rect | transform: transform}
    end

    defp hidden?(point1, point2, point3, %{position: position}) do
      normal =
        Vector3.sub(point1, point2)
        |> Vector3.cross(Vector3.sub(point1, point3))
        |> Vector3.normalize()

      Vector3.dot(normal, Vector3.sub(point1, position)) < 0
    end

    defp get_z([{_, _, z0}, {_, _, z1}, {_, _, z2}, {_, _, z3}]),
      do: (z0 + z1 + z2 + z3) / 4

    defp to_opts([p1, p2, p3, _] = points, camera, options) do
      {backface, options} = Keyword.pop(options, :backface, false)
      Keyword.merge([z: get_z(points), hidden: !backface && hidden?(p1, p2, p3, camera)], options)
    end

    def to_specs(%{points: points, options: options, transform: transform}, camera, transforms) do
      transformed = Transform.project(Tuple.to_list(points), [transform | transforms])

      projected =
        transformed
        |> Camera.project(camera)
        |> Enum.map(fn {x, y, _} -> {x, y} end)

      [{Scenic.Primitive.Quad, List.to_tuple(projected), to_opts(transformed, camera, options)}]
    end
  end
end
