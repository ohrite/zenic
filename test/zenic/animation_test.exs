defmodule Zenic.AnimationTest do
  use ExUnit.Case, async: true

  alias Zenic.{Animation, Animation.Keyframe, Dot, Group}

  describe "frame/3" do
    setup do
      animation =
        Animation.new(100)
        |> Animation.keyframe(0, &Keyframe.transform(&1, :dot, translate: {0, 1, 0}))
        |> Animation.keyframe(50, &Keyframe.transform(&1, :dot, translate: {0, 0, 0}))

      dot = Dot.new(1, id: :dot)
      [animation: animation, dot: dot]
    end

    test "renders a frame at the first keyframe", %{animation: animation, dot: dot} do
      assert animation |> Animation.frame(0) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 1, 0})
    end

    test "interpolates a frame betweeen the first and second keyframes", %{
      animation: animation,
      dot: dot
    } do
      assert animation |> Animation.frame(25) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 0.5, 0})
    end

    test "renders a frame at the middle keyframe", %{animation: animation, dot: dot} do
      assert animation |> Animation.frame(50) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 0, 0})
    end

    test "wraps a keyframe around the end", %{animation: animation, dot: dot} do
      assert animation |> Animation.frame(75) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 0.5, 0})
    end

    test "renders a frame at the last keyframe", %{animation: animation, dot: dot} do
      assert animation |> Animation.frame(100) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 1, 0})
    end

    test "preserves children", %{animation: animation, dot: dot} do
      group = Group.new([dot])

      assert animation |> Animation.frame(100) |> Keyframe.apply(group) ==
               Group.new([Dot.new(1, id: :dot, translate: {0, 1, 0})])
    end

    test "preserves other transforms", %{animation: animation} do
      dot = Dot.new(1, id: :dot, rotate: {0, :math.pi(), 0})

      assert animation |> Animation.frame(100) |> Keyframe.apply(dot) ==
               Dot.new(1, id: :dot, translate: {0, 1, 0}, rotate: {0, :math.pi(), 0})
    end
  end
end
