defmodule Triangulation do
  def count_valid_in_file(filename) do
    parse_file(filename)
    |> count_valid()
  end

  def parse_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.split(&1, ~r/[\s\n]/, trim: true))
    |> Stream.map(&parse_integers/1)
    |> Enum.reduce({[], [[], [], []]}, &remap_columns/2)
    |> join()
  end

  def join({existing, [a, b, c]}) do
    [ a, b, c | existing ]
  end

  def remap_columns([a, b, c], {existing, [p_a, p_b, p_c]}) when length(p_a) < 3 do
    {existing, [[a | p_a], [b | p_b], [c | p_c]]}
  end

  def remap_columns([a, b, c], {existing, [p_a, p_b, p_c]}) do
    { [p_a, p_b, p_c | existing], [[a], [b], [c]] }
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
