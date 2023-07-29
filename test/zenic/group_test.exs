defmodule Zenic.GroupTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Rect, Group, Renderable}

  setup do
    group =
      Group.new(
        [
          Rect.new(1, 1, translate: {0, 0, 2}),
          Rect.new(1, 1, translate: {0, 0, -2})
        ],
        translate: {0, 0, 1}
      )

    [group: group]
  end

  describe "to_specs/1" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "returns two quad primitives", %{group: group, camera: camera} do
      [quad1, quad2] = Renderable.to_specs(group, camera, [])
      assert {Scenic.Primitive.Quad, _, z: 3.0, hidden: false} = quad1
      assert {Scenic.Primitive.Quad, _, z: -1.0, hidden: true} = quad2
    end
  end
end
