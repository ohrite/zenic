defmodule Zenic.Animation.KeyframeTest do
  use ExUnit.Case, async: true

  alias Zenic.{Animation.Keyframe, Transform}

  describe "lerp/3" do
    test "returns a transformed shape" do
      keyframe0 = Keyframe.new(0) |> Keyframe.transform(:thingo, translate: {1, 0, 0})
      keyframe1 = Keyframe.new(1) |> Keyframe.transform(:thingo, translate: {0, 1, 0})
      lerped = Keyframe.lerp(keyframe0, keyframe1, 0.5)
      assert lerped.frame == 0
      assert lerped.transforms == [{:thingo, Transform.new(translate: {0.5, 0.5, 0})}]
    end
  end

  describe "add/2" do
    test "adds the keyframes together" do
      keyframe0 = Keyframe.new(0) |> Keyframe.transform(:thingo, translate: {1, 0, 0})
      keyframe1 = Keyframe.new(0) |> Keyframe.transform(:thingo, translate: {0, 1, 0})
      added = Keyframe.add(keyframe0, keyframe1)
      assert added.transforms == [{:thingo, Transform.new(translate: {1, 1, 0})}]
    end
  end
end
