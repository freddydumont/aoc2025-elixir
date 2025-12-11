defmodule SecretEntrance do
  @doc """
  Calculates the number of times the dial is left pointing at 0 after any rotation in the sequence.
    - numbers go from 0 to 99
    - dial starts at 50
    - R increments dial
    - L decrements dial
  """
  def count_dial_at_zero(path, dial \\ 50, count \\ 0) do
    File.stream!(path, [:trim_bom, encoding: :utf8])
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({dial, count}, fn line, {dial, count} -> parse_line(line, dial, count) end)
    |> elem(1)
  end

  defp parse_line(line, dial, count) do
    {direction, number} = String.split_at(line, 1)

    new_dial =
      String.to_integer(number)
      |> calculate_new_dial(direction, dial)

    {new_dial, increment_if_zero(count, new_dial)}
  end

  defp calculate_new_dial(rotate_by, "R", dial), do: rem(dial + rotate_by, 100)

  defp calculate_new_dial(rotate_by, "L", dial),
    do: rem(dial - rotate_by + 100, 100) |> normalize_dial()

  defp normalize_dial(dial) when dial < 0, do: 100 + dial
  defp normalize_dial(dial), do: dial
  defp increment_if_zero(count, 0), do: count + 1
  defp increment_if_zero(count, _), do: count

  @doc """
  Counts the number of time the dial is on 0, whether during a rotation or at the end of one.
  Same dial functionality as above.
  """
  def count_dial_past_zero(path, dial \\ 50, count \\ 0) do
    File.stream!(path, [:trim_bom, encoding: :utf8])
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({dial, count}, fn line, {dial, count} ->
      parse_line_part_2(line, dial, count)
    end)
    |> elem(1)
  end

  defp parse_line_part_2(line, dial, count) do
    {direction, number} = String.split_at(line, 1)
    value = String.to_integer(number)

    rotations_past_0 =
      case direction do
        "R" ->
          div(dial + value, 100)

        "L" when dial - value == 0 ->
          1

        "L" when dial - value < 0 ->
          (div(dial - value, 100) |> abs()) + if(dial != 0, do: 1, else: 0)

        _ ->
          0
      end

    new_dial = calculate_new_dial(value, direction, dial)
    {new_dial, count + rotations_past_0}
  end
end
