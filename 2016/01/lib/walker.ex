defmodule Walker do
  @spec decode(String.t) :: [{:r | :l, pos_integer}]
  def decode(directions) do
    String.split(directions, ",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&direction_from_string/1)
  end

  defp direction_from_string(direction) do
    {turn_s, steps_s} = String.split_at(direction, 1)

    turn =
      turn_s
      |> String.downcase()
      |> String.to_existing_atom()

    {steps, _} = Integer.parse(steps_s)

    {turn, steps}
  end

  @spec walk([{:r | :l, pos_integer}]) :: pos_integer
  def walk(directions) do
    current = {:north, 0, 0}

    {_dir, x, y} = Enum.reduce(directions, current, &take_steps/2)

    abs(x) + abs(y)
  end

  defp take_steps({turn_direction, paces}, {current_direction, x, y}) do
    new_direction = turn(turn_direction, current_direction)

    {new_x, new_y} = calculate_new_location({new_direction, paces}, {x, y})

    {new_direction, new_x, new_y}
  end

  defp calculate_new_location({:north, steps}, {x, y}) do
    {x, y + steps}
  end

  defp calculate_new_location({:east, steps}, {x, y}) do
    {x + steps, y}
  end

  defp calculate_new_location({:south, steps}, {x, y}) do
    {x, y - steps}
  end

  defp calculate_new_location({:west, steps}, {x, y}) do
    {x - steps, y}
  end

  defp turn(:r, :north), do: :east
  defp turn(:r, :east), do: :south
  defp turn(:r, :south), do: :west
  defp turn(:r, :west), do: :north
  defp turn(:l, :north), do: :west
  defp turn(:l, :west), do: :south
  defp turn(:l, :south), do: :east
  defp turn(:l, :east), do: :north
end
