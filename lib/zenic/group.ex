defmodule Zenic.Group do
  alias Zenic.Transform

  defstruct children: [], options: [], transform: %Transform{}
  @type t :: %__MODULE__{children: [], options: [], transform: Transform.t()}

  @spec new(children :: list, options :: keyword) :: t()
  def new(children, options \\ [])

  def new(children, options) when is_list(children) do
    {transform, options} = Transform.pop(options)
    %__MODULE__{children: children, options: options, transform: transform}
  end

  def new(child, options), do: new([child], options)

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.{Renderable, Transform}

    def apply(
          %{children: children, options: options, transform: from} = group,
          %{transforms: transforms} = keyframe
        ) do
      transform =
        with {:ok, id} <- Keyword.fetch(options, :id),
             {:ok, to} <- Keyword.fetch(transforms, id) do
          Transform.lerp(from, to, 1)
        else
          _ -> from
        end

      children = Enum.map(children, &Renderable.apply(&1, keyframe))
      %{group | transform: transform, children: children}
    end

    def to_specs(%{children: children, transform: transform}, camera, transforms),
      do: Enum.flat_map(children, &Renderable.to_specs(&1, camera, [transform | transforms]))
  end
end
