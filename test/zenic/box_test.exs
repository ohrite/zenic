defmodule Zenic.BoxTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Box, Renderable, Transform}

  describe "to_specs/3" do
    setup do
      camera = Camera.perspective()
      [camera: camera]
    end

    test "renders six faces", %{camera: camera} do
      rect = Box.new(1, 1, 1, north: [id: :north], transform: Transform.new(translate: {0, 0, 4}))
      [_, _, _, _, _, primitive] = Renderable.to_specs(rect, camera)
      assert {{0.0, 0.0, 4.5}, Scenic.Primitive.Quad, _, hidden: false, id: :north} = primitive
    end
  end
end
