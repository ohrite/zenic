defmodule Zenic.Path.Quadratic do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Math

  @default [{0, 0, 0}]
  defstruct points: @default, transform: Transform.new()
  @type t :: %__MODULE__{points: list(Vector3.t()), transform: Transform.t()}

  @spec new(control :: Math.vector_2(), point :: Math.vector_2(), options :: keyword) :: t()
  def new(control, point, options \\ [])

  def new({cx, cy}, {x, y}, options) do
    {transform, _} = Transform.pop(options)

    %__MODULE__{
      points: [{cx, cy, 0}, {x, y, 0}],
      transform: transform
    }
  end

  defimpl Zenic.Path.Renderable, for: __MODULE__ do
    def to_commands(%{points: points, transform: transform}, _, camera, transforms) do
      [{cx, cy, _}, {x, y, _}] =
        points
        |> Transform.project([transform | transforms])
        |> Camera.project(camera)

      [{:quadratic_to, cx, cy, x, y}]
    end
  end
end
