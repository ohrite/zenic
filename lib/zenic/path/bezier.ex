defmodule Zenic.Path.Bezier do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Math

  @default [{0, 0, 0}]
  defstruct points: @default, transform: Transform.new()
  @type t :: %__MODULE__{points: list(Vector3.t()), transform: Transform.t()}

  @spec new(
          control0 :: Math.vector_2(),
          control1 :: Math.vector_2(),
          point :: Math.vector_2(),
          options :: keyword
        ) :: t()
  def new(control0, control1, point, options \\ [])

  def new({c1x, c1y}, {c2x, c2y}, {x, y}, options) do
    {transform, _} = Transform.pop(options)

    %__MODULE__{
      points: [{c1x, c1y, 0}, {c2x, c2y, 0}, {x, y, 0}],
      transform: transform
    }
  end

  defimpl Zenic.Path.Renderable, for: __MODULE__ do
    def to_commands(%{points: points, transform: transform}, _, camera, transforms) do
      [{c1x, c1y, _}, {c2x, c2y, _}, {x, y, _}] =
        points
        |> Transform.project([transform | transforms])
        |> Camera.project(camera)

      [{:bezier_to, c1x, c1y, c2x, c2y, x, y}]
    end
  end
end
