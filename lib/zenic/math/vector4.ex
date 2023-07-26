defmodule Zenic.Math.Vector4 do
  alias Scenic.Math.Matrix

  @type t :: {x :: number, y :: number, z :: number, w :: number}

  @spec project(vector :: t(), matrix :: Scenic.Math.matrix()) :: t()
  def project(vector, matrix)

  def project({ax, ay, az, aw}, matrix) do
    position =
      Matrix.identity()
      |> Matrix.put(3, 0, ax)
      |> Matrix.put(3, 1, ay)
      |> Matrix.put(3, 2, az)
      |> Matrix.put(3, 3, aw)

    projected = Matrix.mul(matrix, position)

    {
      Matrix.get(projected, 3, 0),
      Matrix.get(projected, 3, 1),
      Matrix.get(projected, 3, 2),
      Matrix.get(projected, 3, 3)
    }
  end
end
