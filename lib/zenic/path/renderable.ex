defprotocol Zenic.Path.Renderable do
  alias Zenic.{Camera, Math.Vector3, Transform}
  alias Scenic.Primitive.Path

  @spec to_commands(
          element :: t,
          last_point :: Vector3.t(),
          camera :: Camera.t(),
          transforms :: [Transform.t()]
        ) :: [Path.cmd()]
  def to_commands(element, last_point, camera, transforms \\ [])
end
