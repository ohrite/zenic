defmodule Zenic.Box do
  alias Zenic.{Rect, Transform}

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
    {transform, options} = Transform.pop(options)
    {north_options, options} = Keyword.pop(options, :north, [])
    {south_options, options} = Keyword.pop(options, :south, [])
    {east_options, options} = Keyword.pop(options, :east, [])
    {west_options, options} = Keyword.pop(options, :west, [])
    {top_options, options} = Keyword.pop(options, :top, [])
    {bottom_options, options} = Keyword.pop(options, :bottom, [])
    north = Rect.new(width, height, Keyword.merge(north_options, north(depth)))
    east = Rect.new(depth, height, Keyword.merge(east_options, east(width)))
    west = Rect.new(depth, height, Keyword.merge(west_options, west(width)))
    south = Rect.new(width, height, Keyword.merge(south_options, south(depth)))
    top = Rect.new(width, depth, Keyword.merge(top_options, top(height)))
    bottom = Rect.new(width, depth, Keyword.merge(bottom_options, bottom(height)))

    %__MODULE__{
      faces: {north, east, west, south, top, bottom},
      options: options,
      transform: transform
    }
  end

  defp north(depth), do: [translate: {0, 0, -depth / 2}]
  defp east(width), do: [translate: {width - width / 2, 0, 0}, rotate: {0, :math.pi() / 2, 0}]
  defp west(width), do: [translate: {-width / 2, 0, 0}, rotate: {0, 3 * :math.pi() / 2, 0}]
  defp south(depth), do: [translate: {0, 0, depth / 2}, rotate: {:math.pi(), 0, 0}]
  defp top(height), do: [translate: {0, -height / 2, 0}, rotate: {:math.pi() / 2, 0, 0}]

  defp bottom(height),
    do: [translate: {0, height - height / 2, 0}, rotate: {3 * :math.pi() / 2, 0, 0}]

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.{Renderable, Transform}

    def apply(%{faces: faces, options: options, transform: from} = box, %{transforms: transforms} = keyframe) do
      transform =
        with {:ok, id} <- Keyword.fetch(options, :id),
             {:ok, to} <- Keyword.fetch(transforms, id) do
            Transform.lerp(from, to, 1)
        else
          _ -> from
        end
      faces = Enum.map(faces, &Renderable.apply(&1, keyframe))
      %{box | transform: transform, faces: faces}
    end

    def to_specs(%{faces: faces, transform: transform}, camera, transforms) do
      faces
      |> Tuple.to_list()
      |> Enum.reduce([], &(Renderable.to_specs(&1, camera, [transform | transforms]) ++ &2))
    end
  end
end
