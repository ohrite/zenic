defmodule Zenic.EllipseTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Ellipse, Renderable, Transform}

  describe "to_specs/3" do
    setup do
      [camera: Camera.perspective()]
    end

    test "hides an ellipse that is behind the camera", %{camera: camera} do
      ellipse = Ellipse.new(1, 1, transform: Transform.new(translate: {0, 0, -1}))
      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {{0.0, 0.0, -1.0}, Scenic.Primitive.Path, _, hidden: true} = primitive
    end

    test "renders an ellipse that is in front of the camera", %{camera: camera} do
      ellipse = Ellipse.new(1, 1, transform: Transform.new(translate: {0, 0, 1}))
      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {{0.0, 0.0, 1.0}, Scenic.Primitive.Path, _, hidden: false} = primitive
    end

    test "hides an ellipse that is rotated away from the camera", %{camera: camera} do
      ellipse =
        Ellipse.new(1, 1,
          transform: Transform.new(translate: {0, 0, 1}, rotate: {{:math.pi(), 0, 0}, :xyz})
        )

      [primitive] = Renderable.to_specs(ellipse, camera)
      assert {{0.0, 0.0, 1.0}, Scenic.Primitive.Path, _, hidden: true} = primitive
    end
  end
end
