defmodule Zenic.DotTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Dot, Renderable}

  describe "to_specs/2" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "hides a dot that is behind the camera", %{camera: camera} do
      rect = Dot.new(1, translate: {0, 0, -1})
      [primitive] = Renderable.to_specs(rect, camera)
      assert primitive == {Scenic.Primitive.Circle, 1, t: {0, 0}, z: -1.0, hidden: true}
    end

    test "renders a rect that is in front of the camera", %{camera: camera} do
      rect = Dot.new(1, translate: {0, 0, 1})
      [primitive] = Renderable.to_specs(rect, camera)
      assert primitive == {Scenic.Primitive.Circle, 1, t: {0, 0}, z: 1.0, hidden: false}
    end
  end
end
