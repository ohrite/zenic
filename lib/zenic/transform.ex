defmodule Zenic.Transform do
  alias Zenic.Math.{Quaternion, Vector3, Matrix}
  alias Scenic.Math

  @type t :: %__MODULE__{scale: Vector3.t(), rotate: Quaternion.t(), translate: Vector3.t()}
  defstruct scale: {1, 1, 1}, rotate: {0, 0, 0, 1}, translate: {0, 0, 0}

  @spec new(translate :: Vector3.t(), rotate :: Vector3.t(), scale :: Vector3.t()) :: t()
  def new(translate \\ Vector3.zero(), rotate \\ Vector3.zero(), scale \\ Vector3.one())

  def new({_, _, _} = translate, {_, _, _} = rotate, {_, _, _} = scale),
    do: %__MODULE__{scale: scale, rotate: Quaternion.new(rotate), translate: translate}

  @spec pop(keyword) :: {t(), keyword}
  def pop(options \\ [])

  def pop(options) do
    {scale, options} = Keyword.pop(options, :scale, Vector3.one())
    {rotate, options} = Keyword.pop(options, :rotate, Vector3.zero())
    {translate, options} = Keyword.pop(options, :translate, Vector3.zero())
    {new(translate, rotate, scale), options}
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

  @spec lerp(base :: t(), destination :: t(), amount :: number) :: t()
  def lerp(
        %{translate: t0, rotate: r0, scale: s0} = transform,
        %{translate: t1, rotate: r1, scale: s1},
        amount
      )
      when amount >= 0 and amount <= 1 do
    %{
      transform
      | translate: if(t0 == t1, do: t0, else: Vector3.lerp(t0, t1, amount)),
        rotate: if(r0 == r1, do: r0, else: Quaternion.slerp(r0, r1, amount)),
        scale: if(s0 == s1, do: s0, else: Vector3.lerp(s0, s1, amount))
    }
  end
end
