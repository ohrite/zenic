defmodule Zenic.CameraTest do
  use ExUnit.Case, async: true

  alias Zenic.Camera

  describe "perspective/5" do
    setup do
      [camera: Camera.perspective(10, 10, 0.1, 100.0, 90.0)]
    end

    test "renders a point directly in front of the camera", %{camera: camera} do
      point = {0, 0, 0}
      assert Camera.project(point, camera) == {0, 0, 0}
    end

    test "renders a point inside of the frustrum", %{camera: camera} do
      point = {1, 0, 10}
      {x, y, z} = Camera.project(point, camera)
      assert x == 0.1
      assert y == 0
      assert_in_delta z, 1, 0.01
    end

    test "does not render a point outside of the frustrum", %{camera: camera} do
      point = {100, 0, 10}
      {x, y, z} = Camera.project(point, camera)
      assert x == 10
      assert y == 0
      assert_in_delta z, 1, 0.01
    end
  end

  describe "orthographic/5" do
    setup do
      [camera: Camera.orthographic(0, 100, 0, 100, 0.1, 1000.0)]
    end

    test "renders a point directly in front of the camera", %{camera: camera} do
      point = {0, 0, 0}
      assert Camera.project(point, camera) == {0, 0, 0}
    end

    test "renders a point inside of the frustrum", %{camera: camera} do
      point = {1, 0, 10}
      {x, y, z} = Camera.project(point, camera)
      assert_in_delta x, 0.01, 0.01
      assert y == 0
      assert_in_delta z, -0.02, 0.001
    end

    test "does not render a point outside of the frustrum", %{camera: camera} do
      point = {100, 0, 10}
      {x, y, z} = Camera.project(point, camera)
      assert x == 2
      assert y == 0
      assert_in_delta z, -0.02, 0.001
    end
  end
end
