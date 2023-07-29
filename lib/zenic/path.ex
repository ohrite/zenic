defmodule Zenic.Path do
  alias Zenic.{Transform, Path.Renderable}

  defstruct children: [], options: [], transform: %Transform{}
  @type t :: %__MODULE__{children: [], options: [], transform: Transform.t()}

  @spec new(children :: list, options :: keyword) :: t()
  def new(children \\ [], options \\ [])

  def new(children, options) when is_list(children) do
    {transform, options} = Transform.pop(options)
    %__MODULE__{children: children, options: options, transform: transform}
  end

  def new(child, options), do: new([child], options)

  defimpl Zenic.Renderable, for: __MODULE__ do
    alias Zenic.Math.Vector3

    @origin {0, 0, 0}
    @right {1, 0, 0}
    @up {0, 1, 0}

    defp hidden?(origin, normal, %{position: position}),
      do: Vector3.dot(normal, Vector3.sub(origin, position)) < 0

    defp to_opts({_, _, z} = origin, normal, camera, options) do
      {backface, options} = Keyword.pop(options, :backface, false)
      Keyword.merge([z: z, hidden: !backface && hidden?(origin, normal, camera)], options)
    end

    defp to_commands(children, origin, closed, camera, transforms) do
      {commands, _} =
        children
        |> Enum.reduce({[], origin}, fn child, {commands, last_point} ->
          child_commands = Renderable.to_commands(child, last_point, camera, transforms)
          [last_child_point | _] = Enum.reverse(child.points)
          {commands ++ child_commands, last_child_point}
        end)

      case closed do
        true -> [:begin | commands] ++ [:close_path]
        _ -> [:begin | commands]
      end
    end

    def to_specs(
          %{children: children, options: options, transform: transform},
          camera,
          transforms
        ) do
      [origin, right, up] = Transform.project([@origin, @right, @up], [transform | transforms])

      normal =
        Vector3.sub(origin, right)
        |> Vector3.cross(Vector3.sub(origin, up))
        |> Vector3.normalize()

      {closed, options} = Keyword.pop(options, :closed, false)

      [
        {
          Scenic.Primitive.Path,
          to_commands(children, origin, closed, camera, [transform | transforms]),
          to_opts(origin, normal, camera, options)
        }
      ]
    end
  end
end
