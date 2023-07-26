defmodule Zenic.Math.Vector4Test do
  use ExUnit.Case, async: true

  alias Zenic.Math.Vector4
  alias Scenic.Math.Matrix

  describe "project/2" do
    test "projects the vector using the matrix" do
      vector = {1, 1, 1, 1}
      matrix = Matrix.identity() |> Matrix.mul(2)
      assert Vector4.project(vector, matrix) == {2, 2, 2, 2}
    end
  end
end
