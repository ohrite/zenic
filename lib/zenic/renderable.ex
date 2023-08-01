defprotocol Zenic.Renderable do
  alias Zenic.{Animation.Keyframe, Camera, Transform}

  @type spec :: {module :: atom, data :: term, options :: keyword}

  @spec apply(element :: t, keyframe :: Keyframe.t()) :: t
  def apply(element, keyframe)

  @spec to_specs(element :: t, camera :: Camera.t(), transforms :: [Transform.t()]) :: [spec()]
  def to_specs(element, camera, transforms \\ [])
end
