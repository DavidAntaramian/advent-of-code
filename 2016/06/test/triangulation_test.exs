defmodule TriangulationTest do
  use ExUnit.Case
  doctest Triangulation

  describe "Triangulation.count_valid" do
    test "[5, 10, 25], [5, 15, 11]" do
      input = [[5, 10, 25], [5, 15, 11]]
      assert Triangulation.count_valid(input) == 1
    end
  end
  describe "Triangulation.valid?" do
    test "5, 10, 25" do
      refute Triangulation.valid?([5, 10, 25])
    end

    test "5, 15, 11" do
      assert Triangulation.valid?([5, 15, 11])
    end
  end
end
