defmodule FancyLockTest do
  use ExUnit.Case
  doctest FancyLock

  describe "FancyLock.unlock/1" do
    test "example" do
      directions = [
        [:u, :l, :l],
        [:r, :r, :d, :d, :d],
        [:l, :u, :r, :d, :l],
        [:u, :u, :u, :u, :d]
      ]

      assert FancyLock.unlock(directions) == "1985"
    end
  end

  describe "FancyLock.decode" do
    test "example" do
      directions = """
      ULL
      RRDDD
      LURDL
      UUUUD
      """

      expected = [
        [:u, :l, :l],
        [:r, :r, :d, :d, :d],
        [:l, :u, :r, :d, :l],
        [:u, :u, :u, :u, :d]
      ]

      assert FancyLock.decode(directions) == expected
    end
  end
end
