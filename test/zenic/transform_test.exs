defmodule Zenic.TransformTest do
  use ExUnit.Case, async: true

  alias Zenic.Transform

  setup do
    [points: [{-0.5, -0.5, 0.0}, {0.5, -0.5, 0.0}, {0.5, 0.5, 0.0}, {-0.5, 0.5, 0.0}]]
  end

  describe "project/2" do
    test "projects points with the identity matrix", %{points: points} do
      transform = Transform.new()
      new_points = Transform.project(points, [transform])
      assert new_points == points
    end

    test "projects points with a translation", %{points: points} do
      transform = Transform.new(translate: {1, 1, 1})
      new_points = Transform.project(points, [transform])
      assert new_points == [{0.5, 0.5, 1.0}, {1.5, 0.5, 1.0}, {1.5, 1.5, 1.0}, {0.5, 1.5, 1.0}]
    end

    test "projects points with a scale", %{points: points} do
      transform = Transform.new(scale: {2, 2, 2})
      new_points = Transform.project(points, [transform])
      assert new_points == [{-1, -1, 0.0}, {1, -1, 0.0}, {1, 1, 0.0}, {-1, 1, 0.0}]
    end

    test "projects points with a yaw", %{points: points} do
      transform = Transform.new(rotate: {:math.pi(), 0, 0})
      new_points = Transform.project(points, [transform])
      assert [{-0.5, 0.5, _}, {0.5, 0.5, _}, {0.5, -0.5, _}, {-0.5, -0.5, _}] = new_points

      for {_, _, z} <- new_points do
        assert_in_delta abs(z), 0.00000000000000001, 0.0000000000000001
      end
    end

    test "projects points with a pitch", %{points: points} do
      transform = Transform.new(rotate: {0, :math.pi(), 0})
      new_points = Transform.project(points, [transform])
      assert [{0.5, -0.5, _}, {-0.5, -0.5, _}, {-0.5, 0.5, _}, {0.5, 0.5, _}] = new_points

      for {_, _, z} <- new_points do
        assert_in_delta abs(z), 0.00000000000000001, 0.0000000000000001
      end
    end

    test "projects points with a roll", %{points: points} do
      transform = Transform.new(rotate: {0, 0, :math.pi()})
      new_points = Transform.project(points, [transform])
      assert [{0.5, 0.5, 0.0}, {-0.5, 0.5, 0.0}, {-0.5, -0.5, 0.0}, {0.5, -0.5, 0.0}] = new_points
    end
  end

  describe "lerp/3" do
    test "interpolates a translation" do
      base = Transform.new(translate: {0, 0, 0})
      destination = Transform.new(translate: {1, 1, 1})
      assert Transform.lerp(base, destination, 0.1) == Transform.new(translate: {0.1, 0.1, 0.1})
    end

    test "interpolates a rotation" do
      base = Transform.new(rotate: {:math.pi(), 0, 0})
      destination = Transform.new(rotate: {0, :math.pi(), 0})

      assert %Transform{rotate: {0.9510565162951535, 0.3090169943749474, 0.0, z}} =
               Transform.lerp(base, destination, 0.2)

      assert_in_delta z, 0, 1 / 1_000_000_000_000
    end

    test "interpolates a scale" do
      base = Transform.new(scale: {1, 1, 1})
      destination = Transform.new(scale: {2, 2, 2})

      assert Transform.lerp(base, destination, 0.1) == Transform.new(scale: {1.1, 1.1, 1.1})
    end

    test "interpolates a missing element" do
      base = Transform.new()
      destination = Transform.new(translate: {1, 1, 1})
      assert Transform.lerp(base, destination, 0.1) == Transform.new(translate: {0.1, 0.1, 0.1})
    end
  end
end
