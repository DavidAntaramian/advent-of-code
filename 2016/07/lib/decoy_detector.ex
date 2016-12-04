defmodule DecoyDetector do
  def from_file(filename) do
    File.read!(filename)
    |> sum_block()
  end

  def sum_block(block) do
    String.split(block, ~r/[\s\n]/, trim: true)
    |> Enum.map(&parse/1)
    |> Enum.filter(&valid?/1)
    |> Enum.map(fn %{sector_id: s} -> s end)
    |> Enum.sum()
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
