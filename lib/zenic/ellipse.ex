defmodule Zenic.Ellipse do
  alias Zenic.Path

  defstruct path: Path.new()

  @type t :: %__MODULE__{path: Path.t()}

  @spec new(width :: number, height :: number, options :: keyword) :: t()
  def new(width, height, options \\ [])

  def new(width, height, options) do
    {quarters, options} = Keyword.pop(options, :quarters, 4)
    children = Enum.flat_map(1..quarters, &make_quarter(&1, width / 2, height / 2))
    %__MODULE__{path: Path.new(children, Keyword.put(options, :closed, true))}
  end

  defp make_quarter(1, x, y), do: [Path.Move.new({0, -y}), Path.Quadrant.new({x, -y}, {x, 0})]
  defp make_quarter(2, x, y), do: [Path.Quadrant.new({x, y}, {0, y})]
  defp make_quarter(3, x, y), do: [Path.Quadrant.new({-x, y}, {-x, 0})]
  defp make_quarter(4, x, y), do: [Path.Quadrant.new({-x, -y}, {0, -y})]

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.Renderable

    def apply(%{path: path}, keyframe),
      do: Renderable.apply(path, keyframe)

    def to_specs(%{path: path}, camera, transforms),
      do: Renderable.to_specs(path, camera, transforms)
  end
end
