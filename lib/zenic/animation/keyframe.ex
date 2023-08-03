defmodule Zenic.Animation.Keyframe do
  alias Zenic.{Renderable, Transform}

  defstruct frame: 0, transforms: []
  @type t :: %__MODULE__{frame: integer, transforms: keyword(Transform.t())}

  @spec new(frame :: integer) :: t()
  def new(frame \\ 0)
  def new(frame) when frame >= 0, do: %__MODULE__{frame: frame, transforms: []}

  @spec transform(keyframe :: t(), id :: atom, options :: keyword) :: t()
  def transform(keyframe, id, options \\ [])

  def transform(%{transforms: transforms} = keyframe, id, options) do
    {transform, _} = Transform.pop(options)
    %{keyframe | transforms: Keyword.put(transforms, id, transform)}
  end

  @spec lerp(keyframe :: t(), next_keyframe :: t(), percent :: number) :: t()
  def lerp(keyframe, next_keyframe, percent)

  def lerp(%{transforms: t0} = keyframe, %{transforms: t1}, percent) do
    transforms =
      Enum.map(t0, fn {id, t0} ->
        t1 = Keyword.fetch!(t1, id)
        {id, Transform.lerp(t0, t1, percent)}
      end)

    %{keyframe | transforms: transforms}
  end

  @spec add(keyframe :: t(), other_keyframe :: t()) :: t()
  def add(keyframe, other_keyframe)

  def add(%{transforms: t0} = keyframe, %{transforms: t1}) do
    transforms =
      Enum.map(t0, fn {id, t0} ->
        t1 = Keyword.fetch!(t1, id)
        {id, Transform.add(t0, t1)}
      end)

    %{keyframe | transforms: transforms}
  end

  @spec apply(keyframe :: t(), shape :: term) :: term
  def apply(keyframe, shape), do: Renderable.apply(shape, keyframe)
end
