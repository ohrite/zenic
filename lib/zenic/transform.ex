defmodule Zenic.Transform do
  alias Zenic.Math.{Quaternion, Vector3, Matrix}
  alias Scenic.Math

  @type t :: %__MODULE__{scale: nil | Vector3.t(), rotate: nil | Quaternion.t(), translate: nil | Vector3.t()}
  defstruct scale: nil, rotate: nil, translate: nil

  @type option :: {:translate, Vector3.t()} | {:rotate, Vector3.t()} | {:scale, Vector3.t()}
  @type options :: list(option)

  @spec new(options) :: t()
  def new(options \\ [])

  def new(options) do
    rotate =
      case Keyword.get(options, :rotate) do
        nil -> nil
        rotate -> Quaternion.new(rotate)
      end
    %__MODULE__{
      translate: Keyword.get(options, :translate),
      rotate: rotate,
      scale: Keyword.get(options, :scale)
    }
  end

  @spec pop(keyword) :: {t(), keyword}
  def pop(options \\ [])

  def pop(options) do
    {scale, options} = Keyword.pop(options, :scale)
    {rotate, options} = Keyword.pop(options, :rotate)
    {translate, options} = Keyword.pop(options, :translate)
    {new(translate: translate, rotate: rotate, scale: scale), options}
  end

  @spec project(points :: list(Vector3.t()), transforms :: list(t())) :: list(Vector3.t())
  def project(points, transforms) when is_list(points) do
    matrix =
      Enum.reverse(transforms)
      |> Enum.map(&to_matrix(&1))
      |> Math.Matrix.mul()

    Enum.map(points, &Vector3.project(&1, matrix))
  end

  @spec lerp(transform :: t(), destination :: t(), percent :: number) :: t()
  def lerp(
        %{translate: t0, rotate: r0, scale: s0} = transform,
        %{translate: t1, rotate: r1, scale: s1},
        percent
      )
      when is_number(percent) and percent >= 0 and percent <= 1 do
    %{
      transform
      | translate: lerp_translate(t0, t1, percent),
        rotate: lerp_rotate(r0, r1, percent),
        scale: lerp_scale(s0, s1, percent)
    }
  end

  defp lerp_translate(t0, t1, _) when is_nil(t1), do: t0
  defp lerp_translate(t0, t1, percent) when is_nil(t0), do: Vector3.lerp(Vector3.zero(), t1, percent)
  defp lerp_translate(t0, t1, percent), do: Vector3.lerp(t0, t1, percent)
  defp lerp_rotate(r0, r1, _) when is_nil(r1), do: r0
  defp lerp_rotate(r0, r1, percent) when is_nil(r0), do: Quaternion.slerp(Quaternion.zero(), r1, percent)
  defp lerp_rotate(r0, r1, percent), do: Quaternion.slerp(r0, r1, percent)
  defp lerp_scale(s0, s1, _) when is_nil(s1), do: s0
  defp lerp_scale(s0, s1, percent) when is_nil(s0), do: Vector3.lerp(Vector3.one(), s1, percent)
  defp lerp_scale(s0, s1, percent), do: Vector3.lerp(s0, s1, percent)

  @spec to_matrix(transform :: t()) :: Math.matrix()
  defp to_matrix(%{scale: scale, rotate: rotate, translate: translate}) do
    []
    |> to_rotate(rotate)
    |> to_translate(translate)
    |> to_scale(scale)
    |> Math.Matrix.mul()
  end

  defp to_scale(matrices, nil), do: matrices
  defp to_scale(matrices, scale), do: [Matrix.scale(scale) | matrices]
  defp to_translate(matrices, nil), do: matrices
  defp to_translate(matrices, translate), do: [Matrix.translate(translate) | matrices]
  defp to_rotate(matrices, nil), do: matrices
  defp to_rotate(matrices, rotate), do: [Matrix.rotate(rotate) | matrices]
end
