defmodule Example.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.{Scene, Graph, PubSub}
  alias Zenic.{Animation, Animation.Keyframe, Camera, Ellipse, Group, Rect}

  import Scenic.Primitives
  import Zenic.Scenic

  @camera Camera.perspective()

  @ellipse Ellipse.new(80, 80,
             backface: true,
             stroke: {20, :purple},
             join: :round,
             translate: {0, 0, 40}
           )
  @rect Rect.new(80, 80,
          backface: true,
          fill: :coral,
          stroke: {12, :coral},
          join: :round,
          translate: {0, 0, -40}
        )
  @root Group.new([@ellipse, @rect], id: :root, translate: {0, 0, 125})

  @animation Animation.new(100)
             |> Animation.keyframe(0, &Keyframe.transform(&1, :root, rotate: {0, :math.tau(), 0}))
             |> Animation.keyframe(50, &Keyframe.transform(&1, :root, rotate: {0, :math.pi(), 0}))
             |> Animation.keyframe(100, &Keyframe.transform(&1, :root, rotate: {0, 0, 0}))

  @graph Graph.build()
         |> add_specs_to_graph([
           rrect_spec({150, 150, 10}, fill: :peach_puff, t: {10, 10}),
           illustration_spec({@root, @camera}, id: :illustration, t: {85, 85})
         ])

  @impl Scene
  def init(scene, _param, _opts) do
    PubSub.subscribe(:frame)
    {:ok, assign(push_graph(scene, @graph), graph: @graph)}
  end

  @impl true
  def handle_info({{PubSub, :data}, {:frame, frame, _}}, %{assigns: %{graph: graph}} = scene) do
    root = @animation |> Animation.frame(frame) |> Keyframe.apply(@root)
    graph = Graph.modify(graph, :illustration, &illustration(&1, {root, @camera}))
    {:noreply, assign(push_graph(scene, graph), graph: graph)}
  end

  def handle_info({{Scenic.PubSub, :registered}, {:frame, _}}, scene), do: {:noreply, scene}
end
