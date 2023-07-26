defmodule Zenic.Math.Vector3Test do
  use ExUnit.Case, async: true

  alias Zenic.Math.Vector3
  alias Scenic.Math.Matrix

  describe "zero/0" do
    test "returns a zero vector" do
      assert Vector3.zero() == {0, 0, 0}
    end
  end

  describe "one/0" do
    test "returns a unit vector" do
      assert Vector3.one() == {1, 1, 1}
    end
  end

  describe "add/2" do
    test "adds two vector3s" do
      assert Vector3.add({1, 2, 3}, {4, 5, 6}) == {5, 7, 9}
    end
  end

  describe "sub/2" do
    test "subtracts two vector3s" do
      assert Vector3.sub({4, 5, 6}, {1, 2, 3}) == {3, 3, 3}
    end
  end

  describe "mul/2" do
    test "multiplies a vector by a scalar value" do
      assert Vector3.mul({1, 2, 3}, 3) == {3, 6, 9}
    end
  end

  describe "div/2" do
    test "divides a vector by a scalar value" do
      assert Vector3.div({3, 6, 9}, 3) == {1, 2, 3}
    end
  end

  describe "dot/2" do
    test "calculates the dot product of two vectors" do
      assert Vector3.dot({1, 2, 3}, {4, 5, 6}) == 32
    end

    test "calculates the dot product of two dissimiler vectors" do
      assert Vector3.dot({1, 2, 3}, {-4, -5, -6}) == -32
    end
  end

  describe "cross/2" do
    test "calculates the cross product of two vectors" do
      assert Vector3.cross({1, 2, 3}, {4, 5, 6}) == {-3, 6, -3}
    end
  end

  describe "length_squared/1" do
    test "returns the squared length of the vector" do
      assert Vector3.length_squared({1, 2, 3}) == 14
    end
  end

  describe "length/1" do
    test "returns the length of the vector" do
      assert Vector3.length({1, 2, 2}) == 3
    end
  end

  describe "distance_squared/1" do
    test "returns the squared distance between two vectors" do
      assert Vector3.distance_squared({0, 0, 0}, {2, 2, 2}) == 12
    end
  end

  describe "distance/1" do
    test "returns the distance between two vectors" do
      assert Vector3.distance({0, 0, 0}, {1, 2, 2}) == 3
    end
  end

  describe "normalize/1" do
    test "returns the vector when the length is zero" do
      assert Vector3.normalize({0, 0, 0}) == {0, 0, 0}
    end

    test "returns the normalized vector" do
      assert Vector3.normalize({1, 2, 2}) == {1 / 3, 2 / 3, 2 / 3}
    end
  end

  describe "reflect/2" do
    test "reflects the vector" do
      assert Vector3.reflect({1, 2, 3}, Vector3.normalize({1, 2, 3})) == {-1, -2, -3}
    end
  end

  describe "clamp/3" do
    test "limits the lower bounds of a vector's values" do
      vector = {-1, 1, 0}
      assert Vector3.clamp(vector, {0, 0, 0}, {1, 1, 1}) == {0, 1, 0}
    end

    test "limits the upper bounds of a vector's values" do
      vector = {2, 1, 0}
      assert Vector3.clamp(vector, {0, 0, 0}, {1, 1, 1}) == {1, 1, 0}
    end
  end

  describe "project/2" do
    test "projects the vector using the matrix" do
      vector = {1, 1, 1}
      matrix = Matrix.identity() |> Matrix.mul(2)
      assert Vector3.project(vector, matrix) == {2, 2, 2}
    end
  end

  describe "lerp/3" do
    test "moves the vector toward another vector by a percentage" do
      vector = {-1, -1, -1}
      destination = {1, 1, 1}
      assert Vector3.lerp(vector, destination, 0.5) == {0, 0, 0}
    end
  end
end
