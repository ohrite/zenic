defmodule Zenic.Path.Move do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Math

  @default [{0, 0, 0}]
  defstruct points: @default, transform: Transform.new()
  @type t :: %__MODULE__{points: list(Vector3.t()), transform: Transform.t()}

  @spec new(point :: Math.vector_2(), options :: keyword) :: t()
  def new(point, options \\ [])

  def new({x, y}, options) do
    {transform, _} = Transform.pop(options)

    %__MODULE__{
      points: [{x, y, 0}],
      transform: transform
    }
  end

  defimpl Zenic.Path.Renderable, for: __MODULE__ do
    def to_commands(%{points: points, transform: transform}, _, camera, transforms) do
      [{x, y, _}] =
        points
        |> Transform.project([transform | transforms])
        |> Camera.project(camera)

      [{:move_to, x, y}]
    end
  end
end
