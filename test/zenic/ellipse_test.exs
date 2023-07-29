defmodule Zenic.EllipseTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Ellipse, Renderable}

  describe "to_specs/2" do
    setup do
      [camera: Camera.perspective()]
    end

    test "hides an ellipse that is behind the camera", %{camera: camera} do
      ellipse = Ellipse.new(1, 1, translate: {0, 0, -1})
      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {Scenic.Primitive.Path, _, z: -1.0, hidden: true} = primitive
    end

    test "renders an ellipse that is in front of the camera", %{camera: camera} do
      ellipse = Ellipse.new(1, 1, translate: {0, 0, 1})
      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {Scenic.Primitive.Path, _, z: 1.0, hidden: false} = primitive
    end

    test "hides an ellipse that is rotated away from the camera", %{camera: camera} do
      ellipse = Ellipse.new(1, 1, translate: {0, 0, 1}, rotate: {:math.pi(), 0, 0})

      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {Scenic.Primitive.Path, _, z: 1.0, hidden: true} = primitive
    end
  end
end
