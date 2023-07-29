defmodule Zenic.Camera do
  alias Zenic.Math.{Vector3, Vector4, Matrix}
  alias Scenic.Math

  defstruct position: {0, 0, 0}, matrix: Math.Matrix.identity()
  @type t :: %__MODULE__{position: Vector3.t(), matrix: Math.matrix()}

  @spec perspective() :: t()
  def perspective(aspect \\ 1, fov \\ 90.0, near \\ 0.1, far \\ 1_000.0)

  def perspective(aspect, fov, near, far),
    do: %__MODULE__{position: Vector3.zero(), matrix: Matrix.perspective(aspect, fov, near, far)}

  @spec infinite() :: t()
  def infinite(aspect \\ 1, fov \\ 90.0, near \\ 0.1)

  def infinite(aspect, fov, near),
    do: %__MODULE__{position: Vector3.zero(), matrix: Matrix.infinite(aspect, fov, near)}

  @spec orthographic(
          left :: number,
          right :: number,
          bottom :: number,
          top :: number,
          near :: number,
          far :: number
        ) :: t()
  def orthographic(left \\ 0, right \\ 100, bottom \\ 0, top \\ 100, near \\ 0.1, far \\ 1_000.0)

  def orthographic(left, right, bottom, top, near, far),
    do: %__MODULE__{
      position: Vector3.zero(),
      matrix: Matrix.orthographic(left, right, bottom, top, near, far)
    }

  @spec project(point :: list(Vector3.t()), camera :: t()) :: list(Vector3.t())
  def project(points, camera) when is_list(points),
    do: Enum.map(points, &project_point(&1, camera))

  defp project_point({x, y, z}, %{matrix: matrix}) do
    case Vector4.project({x, y, z, 0.0}, matrix) do
      {x, y, z, 0.0} -> {x, y, z}
      {x, y, z, w} -> {x / w, y / w, z / w}
    end
  end
end
