defmodule SecretEntrance do
  @moduledoc """
  Calculates the password to the secret entrance by counting zeroes on a dial.
    - numbers go from 0 to 99
    - dial starts at 50
    - R increments dial
    - L decrements dial
  """

  @doc """
  Calculates the number of times the dial points at 0 after any rotation in the sequence.
  """
  def count_dial_at_zero(path, dial \\ 50, count \\ 0) do
    File.stream!(path, [:trim_bom, encoding: :utf8])
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({dial, count}, fn line, {dial, count} -> parse_line(line, dial, count, 1) end)
    |> elem(1)
  end

  @doc """
  Counts the number of time the dial clicks on 0, whether during a rotation or at the end of one.
  """
  def count_dial_past_zero(path, dial \\ 50, count \\ 0) do
    File.stream!(path, [:trim_bom, encoding: :utf8])
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({dial, count}, fn line, {dial, count} -> parse_line(line, dial, count, 2) end)
    |> elem(1)
  end

  defp parse_line(line, dial, count, part) do
    {direction, number} = String.split_at(line, 1)
    value = String.to_integer(number)

    new_dial = calculate_new_dial(value, direction, dial)

    {
      new_dial,
      case part do
        1 -> increment_if_zero(count, new_dial)
        2 -> calculate_rotations(direction, dial, value) + count
      end
    }
  end

  defp calculate_new_dial(rotate_by, "R", dial), do: rem(dial + rotate_by, 100)

  defp calculate_new_dial(rotate_by, "L", dial),
    do: rem(dial - rotate_by + 100, 100) |> normalize_dial()

  defp normalize_dial(dial) when dial < 0, do: 100 + dial
  defp normalize_dial(dial), do: dial
  defp increment_if_zero(count, 0), do: count + 1
  defp increment_if_zero(count, _), do: count

  defp calculate_rotations("R", dial, value), do: div(dial + value, 100)
  defp calculate_rotations("L", dial, value) when dial - value == 0, do: 1

  defp calculate_rotations("L", dial, value) when dial - value < 0 do
    # We count 1 pass through 0, unless we started on 0 (counted on last pass, fn above)
    passes_through_zero = if dial == 0, do: 0, else: 1
    full_rotations = div(dial - value, 100) |> abs()

    passes_through_zero + full_rotations
  end

  defp calculate_rotations(_, _, _), do: 0
end
