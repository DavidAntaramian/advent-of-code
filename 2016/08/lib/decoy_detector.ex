defmodule DecoyDetector do
  @original_letter_list String.graphemes("abcdefghijklmnopqrstuvwxyz")

  def from_file(filename) do
    File.read!(filename)
    |> String.split(~r/[\s\n]/, trim: true)
    |> Enum.map(&parse/1)
    |> Enum.filter(&valid?/1)
    |> Enum.map(&decrypt/1)
    |> Enum.sort(fn ({name_a, _}, {name_b, _}) -> name_a < name_b end) 
    |> Enum.filter(fn {name, _} -> name =~ "north" end)
    |> Enum.each(fn {name, sector_id} -> IO.puts IO.ANSI.format(["[ ", :green, name, :reset, " ] - <", :red, sector_id, :reset, ">"]) end)
  end

  def decrypt(%{name: name, sector_id: sector_id}) do
    decrypted_name =
      String.graphemes(name)
      |> Enum.map(&rotate(&1, sector_id))
      |> Enum.join()

    {decrypted_name, to_string(sector_id)}
  end

  defp rotate("-", times) when rem(times, 2) == 1 do
    " "
  end

  defp rotate("-", _) do
    "-"
  end

  defp rotate(letter, times) when rem(times, 26) == 0 do
    letter
  end

  defp rotate(letter, times) do
    movement = rem(times, 26)
    letter_list = letter_list(letter)

    Enum.at(letter_list, movement)
  end

  defp letter_list(letter) do
    {r, l} = Enum.split_while(@original_letter_list, fn(l) -> l != letter end)
    l ++ r
  end

  def parse(name) do
    c = ~r/^(?<name>[a-z\-]+)\-(?<sector_id>\d+)\[(?<checksum>[a-z]+)\]$/

    caps = Regex.named_captures(c, name)

    name = Map.get(caps, "name")
    {sector_id, _} =
      Map.get(caps, "sector_id")
      |> Integer.parse()
    checksum = Map.get(caps, "checksum")

    %{
      name: name,
      sector_id: sector_id,
      checksum: checksum
    }
  end

  def valid?(%{name: name, checksum: checksum}) do
    expected_checksum = generate_checksum(name)

    expected_checksum == checksum
  end

  defp generate_checksum(name) do
    String.graphemes(name)
    |> Enum.reject(fn g -> g == "-" end)
    |> Enum.reduce(%{}, &count_letters/2)
    |> Enum.sort(&sorter/2)
    |> Enum.take(5)
    |> Enum.map(fn {letter, _count} -> letter end)
    |> Enum.join()
  end

  defp count_letters(g, count) do
    Map.update(count, g, 1, &(&1 + 1))
  end

  defp sorter({letter_a, count}, {letter_b, count}) do
    letter_a < letter_b
  end

  defp sorter({_, count_a}, {_, count_b}) do
    count_a > count_b
  end

end
