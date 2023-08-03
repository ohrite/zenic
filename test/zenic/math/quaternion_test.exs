defmodule Zenic.Math.QuaternionTest do
  use ExUnit.Case, async: true

  alias Zenic.Math.Quaternion

  describe "new/1" do
    test "builds a quaternion from a vector of euler angles" do
      assert {x, 0.0, 0.0, w} = Quaternion.new({:math.pi() / 2, 0, 0})
      assert_in_delta x, :math.sqrt(2) / 2, 1 / 1_000_000_000_000_000
      assert_in_delta w, :math.sqrt(2) / 2, 1 / 1_000_000_000_000_000
    end
  end

  describe "normalize/1" do
    test "returns a unit quaternion" do
      assert Quaternion.normalize({0, 0, 0, 1}) == {0, 0, 0, 1}
    end

    test "normalizes a non-unit quaternion" do
      assert {x, 0.0, 0.0, w} = Quaternion.normalize({1, 0, 0, 1})
      assert_in_delta x, :math.sqrt(2) / 2, 1 / 1_000_000_000_000_000
      assert_in_delta w, :math.sqrt(2) / 2, 1 / 1_000_000_000_000_000
    end
  end

  describe "slerp/3" do
    test "spherically interpolates a quaternion" do
      a = {1, 0, 0, 0}
      b = {0, 1, 0, 0}
      {0.9510565162951535, 0.3090169943749474, 0.0, z} = Quaternion.slerp(a, b, 0.2)
      assert_in_delta z, 0, 1 / 1_000_000_000_000
    end
  end

  describe "mul/2" do
    test "multiplies two quaternions derived from euler coordinates" do
      a = Quaternion.new({:math.pi() / 2, 0, 0})
      b = Quaternion.new({0, :math.pi() / 2, 0})
      assert {0.5, 0.5, z, w} = Quaternion.mul(a, b)
      assert z + w == 1
    end

    test "multiplies two quaternions" do
      assert Quaternion.mul({1, 2, 3, 4}, {5, 6, 7, 8}) == {24, 48, 48, -6}
      assert Quaternion.mul({5, 6, 7, 8}, {1, 2, 3, 4}) == {32, 32, 56, -6}
    end
  end
end
