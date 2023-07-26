defmodule Zenic.RectTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Rect, Renderable, Transform}

  describe "to_specs/3" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "hides a rect that is behind the camera", %{camera: camera} do
      rect = Rect.new(1, 1, transform: Transform.new(translate: {0, 0, -1}))
      [primitive] = Renderable.to_specs(rect, camera)
      assert {{0.0, 0.0, -1.0}, Scenic.Primitive.Quad, _, hidden: true} = primitive
    end

    test "renders a rect that is in front of the camera", %{camera: camera} do
      rect = Rect.new(1, 1, transform: Transform.new(translate: {0, 0, 1}))
      [primitive] = Renderable.to_specs(rect, camera)

      assert {{0.0, 0.0, 1.0}, Scenic.Primitive.Quad, {{unit, _}, _, _, _}, hidden: false} =
               primitive

      assert elem(primitive, 2) == {{unit, unit}, {-unit, unit}, {-unit, -unit}, {unit, -unit}}
    end

    test "hides a rect that is rotated away from the camera", %{camera: camera} do
      rect =
        Rect.new(1, 1,
          transform: Transform.new(translate: {0, 0, 1}, rotate: {{:math.pi(), 0, 0}, :xyz})
        )

      [primitive] = Renderable.to_specs(rect, camera)
      assert {{0.0, 0.0, 1.0}, Scenic.Primitive.Quad, _, hidden: true} = primitive
    end
  end
end
