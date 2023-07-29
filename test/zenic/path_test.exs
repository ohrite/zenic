defmodule Zenic.PathTest do
  use ExUnit.Case, async: true

  alias Zenic.{Camera, Path, Renderable}

  describe "to_specs/2" do
    setup do
      [camera: Camera.perspective()]
    end

    test "renders a move command", %{camera: camera} do
      [primitive] =
        Path.new(Path.Move.new({1, 1}), translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert primitive == {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}],
               z: 100.0, hidden: false
             }
    end

    test "renders a move and a quadrant command", %{camera: camera} do
      [primitive] =
        [Path.Move.new({1, 1}), Path.Quadrant.new({0, 1}, {0, 0})]
        |> Path.new(translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}, {:bezier_to, p1, -1.0, 0.0, p2, 0.0, 0.0}],
               z: 100.0, hidden: false
             } = primitive

      assert p1 == -p2
    end

    test "renders a move and an arc command", %{camera: camera} do
      [primitive] =
        [Path.Move.new({1, 1}), Path.Arc.new({0, 1}, {0, 0})]
        |> Path.new(translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}, {:arc_to, p1, -1.0, 0.0, p2, 1}],
               z: 100.0, hidden: false
             } = primitive

      assert p1 == -p2
    end

    test "renders a move and a line command", %{camera: camera} do
      [primitive] =
        [Path.Move.new({1, 1}), Path.Line.new({0, 0})]
        |> Path.new(translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}, {:line_to, 0.0, 0.0}],
               z: 100.0, hidden: false
             } = primitive
    end

    test "renders a move and a bezier curve command", %{camera: camera} do
      [primitive] =
        [Path.Move.new({1, 1}), Path.Bezier.new({1, 0}, {0, 1}, {0, 0})]
        |> Path.new(translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}, {:bezier_to, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0}],
               z: 100.0, hidden: false
             } = primitive
    end

    test "renders a move and a quadratic curve command", %{camera: camera} do
      [primitive] =
        [Path.Move.new({1, 1}), Path.Quadratic.new({1, 0}, {0, 1})]
        |> Path.new(translate: {0, 0, 100})
        |> Renderable.to_specs(camera)

      assert {
               Scenic.Primitive.Path,
               [:begin, {:move_to, 1.0, -1.0}, {:quadratic_to, 1.0, 0.0, 0.0, -1.0}],
               z: 100.0, hidden: false
             } = primitive
    end
  end
end
