defmodule Zenic.Math.Matrix do
  alias Zenic.Math.Vector3
  alias Scenic.Math

  @type rotation :: {point :: Vector3.t(), order :: atom}
  @spec rotate(rotation :: rotation()) :: Math.matrix()
  def rotate(rotation)
  def rotate({{x, y, z}, :xyz}), do: Math.Matrix.mul([yaw(x), pitch(y), roll(z)])

  @spec yaw(radians :: number) :: Math.matrix()
  defp yaw(radians) do
    <<
      1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.cos(radians) * 1.0::float-size(32)-native,
      :math.sin(radians) * -1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.sin(radians) * 1.0::float-size(32)-native,
      :math.cos(radians) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end

  @spec pitch(radians :: number) :: Math.matrix()
  defp pitch(radians) do
    <<
      :math.cos(radians) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.sin(radians) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.sin(radians) * -1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.cos(radians) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end

  @spec roll(radians :: number) :: Math.matrix()
  defp roll(radians) do
    <<
      :math.cos(radians) * 1.0::float-size(32)-native,
      :math.sin(radians) * -1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      :math.sin(radians) * 1.0::float-size(32)-native,
      :math.cos(radians) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end

  @spec translate(translation :: Vector3.t()) :: Math.matrix()
  def translate({x, y, z}) do
    <<
      1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      x * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      y * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native,
      z * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end

  @spec scale(scale :: Vector3.t()) :: Math.matrix()
  def scale({x, y, z}) do
    <<
      x * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      y * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      z * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end
end
