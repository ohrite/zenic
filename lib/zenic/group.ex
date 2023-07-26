defmodule Zenic.Group do
  alias Zenic.{Transform, Renderable}

  defstruct children: [], options: [], transform: %Transform{}
  @type t :: %__MODULE__{children: [], options: [], transform: Transform.t()}

  @spec new(children :: list, options :: keyword) :: t()
  def new(children, options \\ [])

  def new(children, options) do
    {transform, options} = Keyword.pop(options, :transform, Transform.new())
    %__MODULE__{children: children, options: options, transform: transform}
  end

  defimpl Zenic.Renderable, for: __MODULE__ do
    def to_specs(%{children: children, transform: transform}, camera, transforms) do
      Enum.reduce(children, [], fn child, specs ->
        specs ++ Renderable.to_specs(child, camera, [transform | transforms])
      end)
    end
  end
end
