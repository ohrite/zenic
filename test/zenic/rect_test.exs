defmodule Zenic.RectTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Rect, Renderable}

  describe "to_specs/2" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "hides a rect that is behind the camera", %{camera: camera} do
      rect = Rect.new(1, 1, translate: {0, 0, -1})
      [primitive] = Renderable.to_specs(rect, camera)
      assert {Scenic.Primitive.Quad, _, z: -1.0, hidden: true} = primitive
    end

    test "renders a rect that is in front of the camera", %{camera: camera} do
      rect = Rect.new(1, 1, translate: {0, 0, 1})
      [primitive] = Renderable.to_specs(rect, camera)

      assert {Scenic.Primitive.Quad, {{unit, _}, _, _, _}, z: 1.0, hidden: false} =
               primitive

      assert elem(primitive, 1) == {
               {unit, -unit},
               {-unit, -unit},
               {-unit, unit},
               {unit, unit}
             }
    end

    test "hides a rect that is rotated away from the camera", %{camera: camera} do
      rect =
        Rect.new(1, 1, translate: {0, 0, 1}, rotate: {:math.pi(), 0, 0})

      [primitive] = Renderable.to_specs(rect, camera)
      assert {Scenic.Primitive.Quad, _, z: 1.0, hidden: true} = primitive
    end
  end
end
