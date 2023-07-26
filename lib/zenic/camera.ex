defmodule Zenic.Camera do
  alias Zenic.Math.{Vector3, Vector4}
  alias Scenic.{Math, Math.Matrix}

  defmodule Perspective do
    defstruct width: 1, height: 1, near: 0.1, far: 1000.0, fov: 90.0
    @type t :: %__MODULE__{width: number, height: number, near: number, far: number, fov: number}

    @spec new(width :: number, height :: number, near :: number, far :: number, fov :: number) ::
            t()
    def new(width, height, near, far, fov) do
      %__MODULE__{width: width, height: height, near: near, far: far, fov: fov}
    end

    @spec resize(t(), width :: number, height :: number) :: t()
    def resize(projection, width, height), do: %{projection | width: width, height: height}

    @spec to_matrix(t()) :: Math.matrix()
    def to_matrix(%{width: width, height: height, near: near, far: far, fov: fov}) do
      fov_rad = 1.0 / :math.tan(fov / 180.0 * :math.pi() / 2.0)

      Matrix.zero()
      |> Matrix.put(0, 0, width / height * fov_rad)
      |> Matrix.put(1, 1, fov_rad)
      |> Matrix.put(2, 2, far / (far - near))
      |> Matrix.put(2, 3, 1)
      |> Matrix.put(3, 2, -far * near / (far - near))
    end
  end

  defmodule Orthographic do
    defstruct left: 0.0, right: 0.0, bottom: 0.0, top: 0.0, near: 0.0, far: 0.0

    @type t :: %__MODULE__{
            left: number,
            right: number,
            bottom: number,
            top: number,
            near: number,
            far: number
          }

    @spec new(
            left :: number,
            right :: number,
            bottom :: number,
            top :: number,
            near :: number,
            far :: number
          ) :: t()
    def new(left, right, bottom, top, near, far) do
      %__MODULE__{left: left, right: right, bottom: bottom, top: top, near: near, far: far}
    end

    @spec resize(t(), width :: number, height :: number) :: t()
    def resize(%{left: left, bottom: bottom} = orthographic, width, height) do
      %{orthographic | right: left + width, top: bottom + height}
    end

    @spec to_matrix(t()) :: Math.matrix()
    def to_matrix(%{left: left, right: right, bottom: bottom, top: top, near: near, far: far}) do
      Matrix.identity()
      |> Matrix.put(0, 0, 2 / (right - left))
      |> Matrix.put(3, 0, -(right + left) / (right - left))
      |> Matrix.put(1, 1, 2 / (top - bottom))
      |> Matrix.put(3, 1, -(top + bottom) / (top - bottom))
      |> Matrix.put(2, 2, -2 / (far - near))
      |> Matrix.put(3, 2, (-far + near) / (far - near))
    end
  end

  defstruct position: {0.0, 0.0, 0.0}, projection: nil, matrix: Matrix.identity()

  @type t :: %__MODULE__{
          position: Vector3.t(),
          projection: Perspective.t() | Orthographic.t(),
          matrix: Math.matrix()
        }

  @spec perspective() :: t()
  def perspective(width \\ 1, height \\ 1, near \\ 0.1, far \\ 1000.0, fov \\ 90.0)

  def perspective(width, height, near, far, fov) do
    projection = Perspective.new(width, height, near, far, fov)

    %__MODULE__{
      position: {0, 0, 0},
      projection: projection,
      matrix: Perspective.to_matrix(projection)
    }
  end

  @spec orthographic(
          left :: number,
          right :: number,
          bottom :: number,
          top :: number,
          near :: number,
          far :: number
        ) :: t()
  def orthographic(left \\ 0, right \\ 100, bottom \\ 0, top \\ 100, near \\ 0.1, far \\ 1000.0)

  def orthographic(left, right, bottom, top, near, far) do
    projection = Orthographic.new(left, right, bottom, top, near, far)

    %__MODULE__{
      position: {0, 0, 0},
      projection: projection,
      matrix: Orthographic.to_matrix(projection)
    }
  end

  @spec project(point :: Vector3.t() | list(Vector3.t()), camera :: t()) ::
          Vector3.t() | list(Vector3.t())
  def project(points, camera) when is_list(points), do: Enum.map(points, &project(&1, camera))

  def project({x, y, z}, %{matrix: matrix}) do
    case Vector4.project({x, y, z, 0.0}, matrix) do
      {x, y, z, 0.0} -> {x, y, z}
      {x, y, z, w} -> {x / w, y / w, z / w}
    end
  end

  @spec resize(t(), width :: number, height :: number) :: t()
  def resize(%{projection: projection} = camera, width, height) do
    case projection do
      %Orthographic{} ->
        projection = Orthographic.resize(projection, width, height)
        %{camera | projection: projection, matrix: Orthographic.to_matrix(projection)}

      %Perspective{} ->
        projection = Perspective.resize(projection, width, height)
        %{camera | projection: projection, matrix: Perspective.to_matrix(projection)}
    end
  end
end
