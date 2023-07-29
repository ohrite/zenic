defmodule Zenic.Math.Matrix do
  alias Zenic.Math.{Quaternion, Vector3}
  alias Scenic.Math

  @spec rotate(orientation :: Quaternion.t()) :: Math.matrix()
  def rotate(orientation)

  def rotate({x, y, z, w}) do
    <<
      (1 - 2 * y * y - 2 * z * z) * 1.0::float-size(32)-native,
      (2 * x * y + 2 * z * w) * 1.0::float-size(32)-native,
      (2 * x * z - 2 * y * w) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      (2 * x * y - 2 * z * w) * 1.0::float-size(32)-native,
      (1 - 2 * x * x - 2 * z * z) * 1.0::float-size(32)-native,
      (2 * z * y + 2 * x * w) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      (2 * x * z + 2 * y * w) * 1.0::float-size(32)-native,
      (2 * z * y - 2 * x * w) * 1.0::float-size(32)-native,
      (1 - 2 * x * x - 2 * y * y) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end

  @spec translate(translation :: Vector3.t()) :: Math.matrix()
  def translate(translation)

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

  @spec perspective(aspect_ratio :: number, fov :: number, near :: number, far :: number) ::
          Math.matrix()
  def perspective(aspect_ratio, fov, near, far) do
    focal_length = 1 / :math.tan(fov / 2 * :math.pi() / 180.0)
    x = focal_length / aspect_ratio
    y = -focal_length
    a = near / (far - near)
    b = far * near

    <<
      1 / x * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1 / y * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      -1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1 / b * 1.0::float-size(32)-native,
      a / b * 1.0::float-size(32)-native
    >>
  end

  @spec infinite(aspect_ratio :: number, fov :: number, near :: number) :: Math.matrix()
  def infinite(aspect_ratio, fov, near) do
    focal_length = 1 / :math.tan(fov / 2 * :math.pi() / 180.0)
    x = focal_length / aspect_ratio
    y = -focal_length

    <<
      1 / x * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1 / y * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      -1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1 / near * 1.0::float-size(32)-native,
      0.0::float-size(32)-native
    >>
  end

  @spec orthographic(
          left :: number,
          right :: number,
          bottom :: number,
          top :: number,
          near :: number,
          far :: number
        ) :: Math.matrix()
  def orthographic(left, right, bottom, top, near, far) do
    <<
      2 / (right - left) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      -(right + left) / (right - left) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      2 / (top - bottom) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      -(top + bottom) / (top - bottom) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      -2 / (far - near) * 1.0::float-size(32)-native,
      (-far + near) / (far - near) * 1.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      0.0::float-size(32)-native,
      1.0::float-size(32)-native
    >>
  end
end
