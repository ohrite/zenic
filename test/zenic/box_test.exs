defmodule Zenic.BoxTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Box, Renderable}

  describe "to_specs/2" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "renders six faces", %{camera: camera} do
      rect = Box.new(1, 1, 1, north: [id: :north], translate: {0, 0, 4})
      [_, _, _, _, _, primitive] = Renderable.to_specs(rect, camera)
      assert {Scenic.Primitive.Quad, _, z: 3.5, hidden: false, id: :north} = primitive
    end
  end
end
