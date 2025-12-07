defmodule SecretEntrance do
  @moduledoc """
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
    value = String.to_integer(number)

    new_dial =
      case direction do
        "R" -> rem(dial + value, 100)
        "L" -> rem(dial - value + 100, 100)
      end

    {new_dial, increment_if_zero(count, new_dial)}
  end

  defp increment_if_zero(count, 0), do: count + 1
  defp increment_if_zero(count, _), do: count
end
