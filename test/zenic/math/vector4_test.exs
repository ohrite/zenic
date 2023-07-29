defmodule Zenic.Math.Vector4Test do
  use ExUnit.Case, async: true

  alias Zenic.Math.Vector4
  alias Scenic.Math.Matrix

  describe "add/2" do
    test "adds two vectors" do
      assert Vector4.add({1, 2, 3, 4}, {5, 6, 7, 8}) == {6, 8, 10, 12}
    end
  end

  describe "sub/2" do
    test "subtracts two vectors" do
      assert Vector4.sub({5, 6, 7, 8}, {1, 2, 3, 4}) == {4, 4, 4, 4}
    end
  end

  describe "mul/2" do
    test "multiplies a vector by a scalar value" do
      assert Vector4.mul({1, 2, 3, 4}, 3) == {3, 6, 9, 12}
    end

    test "multiplies a vector by another vector" do
      assert Vector4.mul({1, 2, 3, 4}, {1, 2, 3, 4}) == {1, 4, 9, 16}
    end
  end

  describe "div/2" do
    test "divides a vector by a scalar value" do
      assert Vector4.div({3, 6, 9, 12}, 3) == {1, 2, 3, 4}
    end
  end

  describe "dot/2" do
    test "calculates the dot product of two vectors" do
      assert Vector4.dot({1, 2, 3, 4}, {5, 6, 7, 8}) == 70
    end

    test "calculates the dot product of two dissimiler vectors" do
      assert Vector4.dot({1, 2, 3, 4}, {-5, -6, -7, -8}) == -70
    end
  end

  describe "lerp/3" do
    test "moves the vector toward another vector by a percentage" do
      vector = {-1, -1, -1, -1}
      destination = {1, 1, 1, 1}
      assert Vector4.lerp(vector, destination, 0.5) == {0, 0, 0, 0}
    end
  end

  describe "project/2" do
    test "projects the vector using the matrix" do
      vector = {1, 1, 1, 1}
      matrix = Matrix.identity() |> Matrix.mul(2)
      assert Vector4.project(vector, matrix) == {2, 2, 2, 2}
    end
  end
end
