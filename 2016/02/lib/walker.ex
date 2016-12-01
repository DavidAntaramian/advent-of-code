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
    current = {:north, 0, 0, []}

    {_dir, x, y, _coords} = Enum.reduce_while(directions, current, &take_steps/2)

    abs(x) + abs(y)
  end

  defp take_steps({turn_direction, paces}, {current_direction, x, y, coords_visited}) do
    new_direction = turn(turn_direction, current_direction)

    case calculate_new_locations({new_direction, paces}, {x, y}, coords_visited) do
      {new_x, new_y, new_coords_visited} ->
        {:cont, {new_direction, new_x, new_y, new_coords_visited}}
      {:found, {x, y}} ->
        {:halt, {new_direction, x, y, []}}
    end
  end

  defp calculate_new_locations({:north, steps}, {x, y}, coords_visited) do
    new_y = y + steps
    coords =
      y..new_y
      |> Enum.map(fn y_i -> {x, y_i} end)
      |> tl()

    case Enum.find(coords, &Enum.member?(coords_visited, &1)) do
      nil ->
        {x, new_y, coords ++ coords_visited}
      coord ->
        {:found, coord}
    end
  end

  defp calculate_new_locations({:east, steps}, {x, y}, coords_visited) do
    new_x = x + steps
    coords =
      x..new_x
      |> Enum.map(fn x_i -> {x_i, y} end)
      |> tl()

    case Enum.find(coords, &Enum.member?(coords_visited, &1)) do
      nil ->
        {new_x, y, coords ++ coords_visited}
      coord ->
        {:found, coord}
    end
  end

  defp calculate_new_locations({:south, steps}, {x, y}, coords_visited) do
    new_y = y - steps
    coords =
      y..new_y
      |> Enum.map(fn y_i -> {x, y_i} end)
      |> tl()

    case Enum.find(coords, &Enum.member?(coords_visited, &1)) do
      nil ->
        {x, new_y, coords ++ coords_visited}
      coord ->
        {:found, coord}
    end
  end

  defp calculate_new_locations({:west, steps}, {x, y}, coords_visited) do
    new_x = x - steps
    coords =
      x..new_x
      |> Enum.map(fn x_i -> {x_i, y} end)
      |> tl()

    case Enum.find(coords, &Enum.member?(coords_visited, &1)) do
      nil ->
        {new_x, y, coords ++ coords_visited}
      coord ->
        {:found, coord}
    end
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
