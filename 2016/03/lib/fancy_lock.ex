defmodule FancyLock do
  @keypad %{
    1 => %{
      :r => 2,
      :d => 4
    },
    2 => %{
      :l => 1,
      :r => 3,
      :d => 5
    },
    3 => %{
      :l => 2,
      :d => 6
    },
    4 => %{
      :u => 1,
      :r => 5,
      :d => 7
    },
    5 => %{
      :u => 2,
      :r => 6,
      :l => 4,
      :d => 8
    },
    6 => %{
      :u => 3,
      :l => 5,
      :d => 9
    },
    7 => %{
      :u => 4,
      :r => 8
    },
    8 => %{
      :u => 5,
      :l => 7,
      :r => 9
    },
    9 => %{
      :u => 6,
      :l => 8
    }
  }

  def from_file(filename) do
    File.read!(filename)
    |> decode()
    |> unlock()
  end

  @spec decode(String.t) :: [[:u | :l | :r | :d]]
  def decode(directions) do
    String.split(directions, "\n", trim: true)
    |> Enum.map(&decode_line/1)
  end

  defp decode_line(line) do
    decode_line(line, [])
    |> Enum.reverse()
  end

  defp decode_line(<<>>, directions) do
    directions
  end

  defp decode_line(<< 76, r :: binary >>, directions) do
    decode_line(r, [ :l | directions ])
  end

  defp decode_line(<< 85 , r :: binary >>, directions) do
    decode_line(r, [ :u | directions ])
  end

  defp decode_line(<< 82 , r :: binary >>, directions) do
    decode_line(r, [ :r | directions ])
  end

  defp decode_line(<< 68 , r :: binary >>, directions) do
    decode_line(r, [ :d | directions ])
  end

  def unlock(directions) do
    start_position = 5
    {code, _} = Enum.map_reduce(directions, start_position, &follow_directions/2)

    Enum.join(code)
  end

  defp follow_directions(directions, start_position) do
    next_position = Enum.reduce(directions, start_position, &move/2)
    {Integer.to_string(next_position), next_position}
  end

  defp move(direction, current_position) do
    Map.fetch!(@keypad, current_position)
    |> Map.get(direction, current_position)
  end
end
