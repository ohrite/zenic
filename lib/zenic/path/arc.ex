defmodule Zenic.Path.Arc do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Math

  @default [{0, 0, 0}]
  defstruct points: @default, radius: 1, transform: Transform.new()
  @type t :: %__MODULE__{points: list(Vector3.t()), radius: number, transform: Transform.t()}

  @spec new(
          point0 :: Math.vector_2(),
          point1 :: Math.vector_2(),
          radius :: number,
          options :: keyword
        ) :: t()
  def new(point0, point1, radius \\ 1, options \\ [])

  def new({x1, y1}, {x2, y2}, radius, options) do
    {transform, _} = Transform.pop(options)

    %__MODULE__{
      points: [{x1, y1, 0}, {x2, y2, 0}],
      radius: radius,
      transform: transform
    }
  end

  defimpl Zenic.Path.Renderable, for: __MODULE__ do
    def to_commands(
          %{points: points, radius: radius, transform: transform},
          _,
          camera,
          transforms
        ) do
      [{x1, y1, _}, {x2, y2, _}] =
        points
        |> Transform.project([transform | transforms])
        |> Camera.project(camera)

      [{:arc_to, x1, y1, x2, y2, radius}]
    end
  end
end
