defmodule Zenic.Math.Quaternion do
  alias Zenic.Math.{Vector4, Vector3}

  # This uses a JPL notation, where w is the last component
  @type t :: {x :: number, y :: number, z :: number, w :: number}

  @spec zero() :: t()
  def zero(), do: {0, 0, 0, 1}

  @spec new(Vector3.t()) :: t()
  def new(euler \\ Vector3.zero())

  def new({x, y, z}) do
    {c_roll, s_roll} = {:math.cos(x / 2), :math.sin(x / 2)}
    {c_pitch, s_pitch} = {:math.cos(y / 2), :math.sin(y / 2)}
    {c_yaw, s_yaw} = {:math.cos(z / 2), :math.sin(z / 2)}

    normalize({
      s_roll * c_pitch * c_yaw - c_roll * s_pitch * s_yaw,
      c_roll * s_pitch * c_yaw + s_roll * c_pitch * s_yaw,
      c_roll * c_pitch * s_yaw - s_roll * s_pitch * c_yaw,
      c_roll * c_pitch * c_yaw + s_roll * s_pitch * s_yaw
    })
  end

  @spec normalize(quaternion :: t()) :: t()
  def normalize(quaternion)

  def normalize({x, y, z, w} = quaternion) do
    case x * x + y * y + z * z + w * w do
      1.0 -> quaternion
      normal -> Vector4.mul(quaternion, 1.0 / :math.sqrt(normal))
    end
  end

  @spec slerp(a :: t(), b :: t(), t :: number) :: t()
  def slerp(a, b, t)

  def slerp(a, b, t) when t >= 0.0 and t <= 1.0 do
    {a, angle} =
      case Vector4.dot(a, b) do
        angle when angle < 0.0 -> {Vector4.mul(a, -1.0), -1.0 * angle}
        angle -> {a, angle}
      end

    theta = :math.acos(angle)
    sin_theta = :math.sin(theta)

    Vector4.mul(a, :math.sin(theta * (1.0 - t)) / sin_theta)
    |> Vector4.add(Vector4.mul(b, :math.sin(theta * t) / sin_theta))
  end
end
