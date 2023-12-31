defmodule Zenic.Dot do
  alias Zenic.Transform

  defstruct radius: 1, transform: Transform.new(), options: []

  @type t :: %__MODULE__{radius: number, transform: Transform.t(), options: keyword}

  @spec new(radius :: number, options :: keyword) :: t()
  def new(radius, options \\ [])

  def new(radius, options) do
    {transform, options} = Transform.pop(options)
    %__MODULE__{radius: radius, options: options, transform: transform}
  end

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.{Camera, Transform}

    @origin {0, 0, 0}

    def apply(%{transform: from, options: options} = dot, %{transforms: transforms}) do
      transform =
        with {:ok, id} <- Keyword.fetch(options, :id),
             {:ok, to} <- Keyword.fetch(transforms, id) do
          Transform.lerp(from, to, 1)
        else
          _ -> from
        end

      %{dot | transform: transform}
    end

    def to_specs(%{radius: radius, options: options, transform: transform}, camera, transforms) do
      [{_, _, z}] = transformed = Transform.project([@origin], [transform | transforms])

      [{x, y, _}] =
        transformed
        |> Camera.project(camera)

      [{Scenic.Primitive.Circle, radius, Keyword.merge(options, t: {x, y}, z: z, hidden: z < 0)}]
    end
  end
end
