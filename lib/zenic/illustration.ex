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
      |> Enum.reduce([], fn renderable, specs ->
        Enum.reduce(Renderable.to_specs(renderable, camera), specs, fn {{_, _, z}, module, data,
                                                                        opts},
                                                                       specs ->
          [{z, renderable_spec(module, data, opts)} | specs]
        end)
      end)
      |> Enum.sort(fn {z1, _}, {z2, _} -> z1 > z2 end)
      |> Enum.reduce([], fn {_, spec}, specs -> [spec | specs] end)

    graph =
      Graph.build()
      |> add_specs_to_graph(specs)

    {:ok,
     assign(push_graph(scene, graph), graph: graph, renderables: renderables, camera: camera)}
  end
end
