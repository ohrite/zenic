defmodule Zenic.Transform do
  alias Zenic.Math.Vector3
  alias Zenic.Math.Matrix
  alias Scenic.Math

  @type t :: %__MODULE__{scale: Vector3.t(), rotate: Matrix.rotation(), translate: Vector3.t()}
  defstruct scale: {1, 1, 1}, rotate: {{0, 0, 0}, :xyz}, translate: {0, 0, 0}

  @type option :: {:translate, Vector3.t()} | {:rotate, Matrix.rotation()} | {:scale, Vector3.t()}
  @type options :: [option()]

  @spec new(options) :: t()
  def new(options \\ [])

  def new(options) do
    %__MODULE__{
      scale: Keyword.get(options, :scale, {1, 1, 1}),
      rotate: Keyword.get(options, :rotate, {{0, 0, 0}, :xyz}),
      translate: Keyword.get(options, :translate, {0, 0, 0})
    }
  end

  @spec project(points :: list(Vector3.t()), transforms :: list(t())) :: list(Vector3.t())
  def project(points, transforms) when is_list(points) do
    matrix =
      Enum.reverse(transforms)
      |> Enum.map(&to_matrix(&1))
      |> Math.Matrix.mul()

    Enum.map(points, &Vector3.project(&1, matrix))
  end

  @spec to_matrix(transform :: t()) :: Math.matrix()
  defp to_matrix(%{scale: scale, rotate: rotate, translate: translate}) do
    Math.Matrix.mul([
      Matrix.scale(scale),
      Matrix.translate(translate),
      Matrix.rotate(rotate)
    ])
  end
end
