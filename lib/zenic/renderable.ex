defprotocol Zenic.Renderable do
  alias Zenic.{Camera, Transform}
  alias Zenic.Math.Vector3

  @type spec :: {center :: Vector3.t(), module :: atom, data :: term, options :: keyword}

  @spec to_specs(element :: t, camera :: Camera.t(), transforms :: list(Transform.t())) ::
          list(spec)
  def to_specs(element, camera, transforms \\ [])
end
