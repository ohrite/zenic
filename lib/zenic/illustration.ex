defmodule Zenic.Illustration do
  use Scenic.Component

  alias Scenic.{Component, Graph, Scene}
  alias Zenic.Renderable

  import Zenic.Scenic
  import Scenic.Primitives

  @impl Component
  def validate({renderables, camera}) when is_list(renderables), do: {:ok, {renderables, camera}}

  def validate(invalid),
    do: {:error, "#{__MODULE__} expected {[renderable], camera} but got #{inspect(invalid)}"}

  @impl Scene
  def init(scene, {renderables, camera}, _) do
    specs =
      renderables
      |> Enum.flat_map(&Renderable.to_specs(&1, camera))
      |> Enum.sort(fn {_, _, opts1}, {_, _, opts2} ->
        Keyword.fetch!(opts1, :z) < Keyword.fetch!(opts2, :z)
      end)
      |> Enum.reduce([], fn {module, data, opts}, specs ->
        [renderable_spec(module, data, opts) | specs]
      end)

    graph =
      Graph.build()
      |> add_specs_to_graph(specs)

    {:ok,
     assign(push_graph(scene, graph), graph: graph, renderables: renderables, camera: camera)}
  end
end
