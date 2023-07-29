defmodule Zenic.Path.Quadrant do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Math

  @default [{0, 0, 0}]
  defstruct points: @default, transform: Transform.new()
  @type t :: %__MODULE__{points: list(Vector3.t()), transform: Transform.t()}

  @spec new(point1 :: Math.vector_2(), point2 :: Math.vector_2(), options :: keyword) :: t()
  def new(point1, point2, options \\ [])

  def new({x1, y1}, {x2, y2}, options) do
    {transform, _} = Transform.pop(options)

    %__MODULE__{
      points: [{x1, y1, 0}, {x2, y2, 0}],
      transform: transform
    }
  end

  defimpl Zenic.Path.Renderable, for: __MODULE__ do
    # Approximate a circle with a cubic Bézier
    # https://spencermortensen.com/articles/bezier-circle/
    @mortensens 0.5519150244935105707435627

    alias Scenic.Math.Vector2

    def to_commands(%{points: points, transform: transform}, last_point, camera, transforms) do
      [{x0, y0, _}, {x1, y1, _}, {x2, y2, _}] =
        [last_point | points]
        |> Transform.project([transform | transforms])
        |> Camera.project(camera)

      {cx1, cy1} = {x0, y0} |> Vector2.lerp({x1, y1}, @mortensens)
      {cx2, cy2} = {x1, y1} |> Vector2.lerp({x2, y2}, @mortensens)
      [{:bezier_to, cx1, cy1, cx2, cy2, x2, y2}]
    end
  end
end
