defmodule WalkerTest do
  use ExUnit.Case
  doctest Walker

  describe "Walker.walk/1" do
    test "r2, l3" do
      directions = [{:r, 2}, {:l, 3}]

      assert Walker.walk(directions) == 5
    end

    test "r2, r2, r2" do
      directions = [{:r, 2}, {:r, 2}, {:r, 2}]

      assert Walker.walk(directions) == 2
    end

    test "r5, l5, r5, r3" do
      directions = [{:r, 5}, {:l, 5}, {:r, 5}, {:r, 3}]

      assert Walker.walk(directions) == 12
    end
  end

  describe "Walker.decode/1" do
    test "r2, l3" do
      directions = "R2, R3"

      assert Walker.decode(directions) == [{:r, 2}, {:r, 3}]
    end

    test "r2, r2, r2" do
      directions = "r2, r2, r2"

      assert Walker.decode(directions) == [{:r, 2}, {:r, 2}, {:r, 2}]
    end

    test "r5, l5, r5, r3" do
      directions = "r5, l5, r5, r3"

      assert Walker.decode(directions) == [{:r, 5}, {:l, 5}, {:r, 5}, {:r, 3}]
    end
  end
end
