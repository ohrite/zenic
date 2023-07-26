defmodule Zenic.Box do
  alias Zenic.{Transform, Rect, Renderable}

  @default {Rect.new(1, 1), Rect.new(1, 1), Rect.new(1, 1), Rect.new(1, 1), Rect.new(1, 1),
            Rect.new(1, 1)}
  defstruct faces: @default, options: [], transform: Transform.new()

  @type t :: %__MODULE__{
          faces: {Rect.t(), Rect.t(), Rect.t(), Rect.t(), Rect.t(), Rect.t()},
          options: keyword,
          transform: Transform.t()
        }

  @spec new(width :: number, height :: number, depth :: number, options :: keyword) :: t()
  def new(width \\ 1, height \\ 1, depth \\ 1, options \\ [])

  def new(width, height, depth, options) do
    {transform, options} = Keyword.pop(options, :transform, Transform.new())
    {north_options, options} = Keyword.pop(options, :north, [])
    {south_options, options} = Keyword.pop(options, :south, [])
    {east_options, options} = Keyword.pop(options, :east, [])
    {west_options, options} = Keyword.pop(options, :west, [])
    {top_options, options} = Keyword.pop(options, :top, [])
    {bottom_options, options} = Keyword.pop(options, :bottom, [])
    north = Rect.new(width, height, Keyword.merge(north_options, transform: north(depth)))
    east = Rect.new(depth, height, Keyword.merge(east_options, transform: east(width)))
    west = Rect.new(depth, height, Keyword.merge(west_options, transform: west(width)))
    south = Rect.new(width, height, Keyword.merge(south_options, transform: south(depth)))
    top = Rect.new(width, depth, Keyword.merge(top_options, transform: top(height)))
    bottom = Rect.new(width, depth, Keyword.merge(bottom_options, transform: bottom(height)))

    %__MODULE__{
      faces: {north, east, west, south, top, bottom},
      options: options,
      transform: transform
    }
  end

  defp north(depth), do: Transform.new(translate: {0, 0, depth / 2}, rotate: {{0, 0, 0}, :xyz})

  defp east(width),
    do: Transform.new(translate: {-width / 2, 0, 0}, rotate: {{0, 3 * :math.pi() / 2, 0}, :xyz})

  defp west(width),
    do:
      Transform.new(translate: {width - width / 2, 0, 0}, rotate: {{0, :math.pi() / 2, 0}, :xyz})

  defp south(depth),
    do: Transform.new(translate: {0, 0, -depth / 2}, rotate: {{:math.pi(), 0, 0}, :xyz})

  defp top(height),
    do:
      Transform.new(
        translate: {0, height - height / 2, 0},
        rotate: {{3 * :math.pi() / 2, 0, 0}, :xyz}
      )

  defp bottom(height),
    do: Transform.new(translate: {0, -height / 2, 0}, rotate: {{:math.pi() / 2, 0, 0}, :xyz})

  defimpl Zenic.Renderable, for: __MODULE__ do
    def to_specs(%{faces: faces, transform: transform}, camera, transforms) do
      faces
      |> Tuple.to_list()
      |> Enum.reduce([], &(Renderable.to_specs(&1, camera, [transform | transforms]) ++ &2))
    end
  end
end
