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

  @spec add(vector4_a :: t(), vector4_b :: t()) :: t()
  def add(vector4_a, vector4_b)
  def add({ax, ay, az, aw}, {bx, by, bz, bw}), do: {ax + bx, ay + by, az + bz, aw + bw}

  @spec sub(vector4_a :: t(), vector4_b :: t()) :: t()
  def sub(vector4_a, vector4_b)
  def sub({ax, ay, az, aw}, {bx, by, bz, bw}), do: {ax - bx, ay - by, az - bz, aw - bw}

  @spec mul(vector4 :: t(), scalar :: number | t()) :: t()
  def mul(vector4, multiplier)
  def mul({ax, ay, az, aw}, s) when is_number(s), do: {ax * s, ay * s, az * s, aw * s}
  def mul({ax, ay, az, aw}, {bx, by, bz, bw}), do: {ax * bx, ay * by, az * bz, aw * bw}

  @spec div(vector4 :: t(), scalar :: number) :: t()
  def div(vector4, scalar)
  def div({ax, ay, az, aw}, s) when is_number(s), do: {ax / s, ay / s, az / s, aw / s}

  @spec dot(vector4_a :: t(), vector4_b :: t()) :: number
  def dot(vector4_a, vector4_b)
  def dot({ax, ay, az, aw}, {bx, by, bz, bw}), do: ax * bx + ay * by + az * bz + aw * bw

  @spec lerp(vector_a :: t(), vector_b :: t(), t :: number) :: t()
  def lerp(a, b, t)

  def lerp(a, b, t) when is_float(t) and t >= 0.0 and t <= 1.0 do
    b
    |> sub(a)
    |> mul(t)
    |> add(a)
  end
end
