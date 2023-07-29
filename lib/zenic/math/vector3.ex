defmodule Zenic.Math.Vector3 do
  alias Scenic.Math.Matrix

  @type t :: {x :: number, y :: number, z :: number}

  def zero(), do: {0.0, 0.0, 0.0}
  def one(), do: {1.0, 1.0, 1.0}

  @spec add(vector3_a :: t(), vector3_b :: t()) :: t()
  def add(vector3_a, vector3_b)
  def add({ax, ay, az}, {bx, by, bz}), do: {ax + bx, ay + by, az + bz}

  @spec sub(vector3_a :: t(), vector3_b :: t()) :: t()
  def sub(vector3_a, vector3_b)
  def sub({ax, ay, az}, {bx, by, bz}), do: {ax - bx, ay - by, az - bz}

  @spec mul(vector3 :: t(), scalar :: number | t()) :: t()
  def mul(vector3, multiplier)
  def mul({ax, ay, az}, s) when is_number(s), do: {ax * s, ay * s, az * s}
  def mul({ax, ay, az}, {bx, by, bz}), do: {ax * bx, ay * by, az * bz}

  @spec div(vector3 :: t(), scalar :: number) :: t()
  def div(vector3, scalar)
  def div({ax, ay, az}, s) when is_number(s), do: {ax / s, ay / s, az / s}

  @spec dot(vector3_a :: t(), vector3_b :: t()) :: number
  def dot(vector3_a, vector3_b)
  def dot({ax, ay, az}, {bx, by, bz}), do: ax * bx + ay * by + az * bz

  @spec cross(vector3_a :: t(), vector3_b :: t()) :: t()
  def cross(vector3_a, vector3_b)

  def cross({ax, ay, az}, {bx, by, bz}),
    do: {ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx}

  @spec length_squared(vector3 :: t()) :: number
  def length_squared(vector3)
  def length_squared({ax, ay, az}), do: ax * ax + ay * ay + az * az

  @spec length(vector3 :: t()) :: number
  def length(vector3)
  def length(vector3), do: vector3 |> length_squared() |> :math.sqrt()

  @spec distance_squared(vector3_a :: t(), vector3_b :: t()) :: number
  def distance_squared(vector3_a, vector3_b)

  def distance_squared({ax, ay, az}, {bx, by, bz}),
    do: (bx - ax) * (bx - ax) + (by - ay) * (by - ay) + (bz - az) * (bz - az)

  @spec distance(vector3_a :: t(), vector3_b :: t()) :: number
  def distance(vector3_a, vector3_b)
  def distance(a, b), do: distance_squared(a, b) |> :math.sqrt()

  @spec normalize(vector3 :: t()) :: t()
  def normalize(vector3)

  def normalize({ax, ay, az}) do
    case __MODULE__.length({ax, ay, az}) do
      0.0 -> {ax, ay, az}
      length -> {ax / length, ay / length, az / length}
    end
  end

  @spec reflect(vector3 :: t(), normal :: t()) :: t()
  def reflect(vector3, normal)
  def reflect(vector3, normal), do: sub(vector3, mul(normal, 2 * dot(vector3, normal)))

  @spec truncate(vector :: t()) :: t()
  def truncate(vector)
  def truncate({ax, ay, az}), do: {trunc(ax), trunc(ay), trunc(az)}

  @spec clamp(vector3 :: t(), min :: t(), max :: t()) :: t()
  def clamp({vx, vy, vz}, {minx, miny, minz}, {maxx, maxy, maxz}) do
    x =
      cond do
        vx < minx -> minx
        vx > maxx -> maxx
        true -> vx
      end

    y =
      cond do
        vy < miny -> miny
        vy > maxy -> maxy
        true -> vy
      end

    z =
      cond do
        vz < minz -> minz
        vz > maxz -> maxz
        true -> vz
      end

    {x, y, z}
  end

  @spec project(vector :: t(), matrix :: Scenic.Math.matrix()) :: t()
  def project(vector, matrix)

  def project({ax, ay, az}, matrix) do
    position =
      Matrix.identity()
      |> Matrix.put(3, 0, ax)
      |> Matrix.put(3, 1, ay)
      |> Matrix.put(3, 2, az)

    projected = Matrix.mul(matrix, position)
    {Matrix.get(projected, 3, 0), Matrix.get(projected, 3, 1), Matrix.get(projected, 3, 2)}
  end

  @spec lerp(vector_a :: t(), vector_b :: t(), t :: number) :: t()
  def lerp(a, b, t)

  def lerp(a, b, t) when is_float(t) and t >= 0.0 and t <= 1.0 do
    b
    |> sub(a)
    |> mul(t)
    |> add(a)
  end
end
