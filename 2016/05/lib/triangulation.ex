defmodule Triangulation do
  def count_valid_in_file(filename) do
    parse_file(filename)
    |> count_valid()
  end

  def parse_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.split(&1, ~r/[\s\n]/, trim: true))
    |> Enum.map(&parse_integers/1)
    |> IO.inspect()
  end

  def parse_integers(a) do
    Enum.map(a, fn i_s ->
      {i, _} = Integer.parse(i_s)
      i
    end)
  end

  def count_valid(triangles) do
    Enum.filter(triangles, &valid?/1)
    |> Enum.count()
  end

  def valid?([a, b, c]) do
    (a + b > c) and (a + c > b) and (b + c > a)
  end
end
