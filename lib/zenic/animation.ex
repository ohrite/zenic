defmodule Zenic.Animation do
  alias Zenic.Animation.Keyframe

  defstruct frames: 1, keyframes: []
  @type t :: %__MODULE__{frames: integer, keyframes: [Keyframe.t()]}

  @spec new(frames :: integer) :: t()
  def new(frames)
  def new(frames) when frames >= 0, do: %__MODULE__{frames: frames, keyframes: []}

  @spec keyframe(animation :: t(), frame :: integer, (Keyframe.t -> Keyframe.t)) :: t()
  def keyframe(animation, frame, builder)
  def keyframe(%__MODULE__{keyframes: keyframes, frames: frames} = animation, frame, builder)
    when frame >= 0 and frame <= frames,
    do: %{animation | keyframes: keyframes ++ [Keyframe.new(frame) |> builder.()]}

  @spec frame(animation :: t(), frame :: integer) :: term
  def frame(animation, frame)
  def frame(%{keyframes: keyframes, frames: frames}, frame) do
    frame = rem(frame, frames)

    {last_keyframes, next_keyframes} =
      Enum.split_with(keyframes, fn %{frame: index} -> index <= frame end)

    [last_keyframe | _] = Enum.reverse(last_keyframes)
    [next_keyframe | _] =
      case next_keyframes do
        [] ->
          with keyframe = Enum.at(keyframes, 0), do: [%{keyframe | frame: keyframe.frame + frames}]
        _ -> next_keyframes
      end

    percent = (frame - last_keyframe.frame) / (next_keyframe.frame - last_keyframe.frame)
    Keyframe.lerp(last_keyframe, next_keyframe, percent)
  end
end
