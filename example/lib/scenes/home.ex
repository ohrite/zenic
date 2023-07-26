defmodule Example.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.{Scene, Graph, PubSub}
  alias Zenic.{Camera, Ellipse, Group, Rect, Transform}

  import Scenic.Primitives
  import Zenic.Scenic

  @camera Camera.perspective(150, 150, 0.1, 1000.0, 10.0)
  @rect Rect.new(20, 20, backface: true, fill: :salmon, stroke: {20, :salmon}, join: :round, transform: Transform.new(translate: {0, 0, -5}))
  @ellipse Ellipse.new(20, 20, backface: true, stroke: {20, :purple}, join: :round, transform: Transform.new(translate: {0, 0, 5}))
  @root Group.new([@ellipse, @rect], transform: Transform.new(scale: {100, 100, 1.0}, translate: {20, 20, 300}))

  @graph Graph.build() |> add_specs_to_graph([
    rrect_spec({150, 150, 10}, fill: :peach_puff, t: {10, 10}),
    illustration_spec({[@root], @camera}, id: :illustration, t: {10, 10})
  ])

  @impl Scene
  def init(scene, _param, _opts) do
    PubSub.subscribe(:frame)
    {:ok, assign(push_graph(scene, @graph), graph: @graph)}
  end

  @impl true
  def handle_info({{PubSub, :data}, {:frame, frame, _}}, %{assigns: %{graph: graph}} = scene) do
    root = %{@root | transform: %{@root.transform | rotate: {{0, frame / 15, 0}, :xyz}}}
    graph = Graph.modify(graph, :illustration, &illustration(&1, {[root], @camera}))
    {:noreply, assign(push_graph(scene, graph), graph: graph)}
  end
end
