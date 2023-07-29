defprotocol Zenic.Renderable do
  alias Zenic.{Camera, Transform}

  @type spec :: {module :: atom, data :: term, options :: keyword}

  @spec to_specs(element :: t, camera :: Camera.t(), transforms :: [Transform.t()]) :: [spec()]
  def to_specs(element, camera, transforms \\ [])
end
