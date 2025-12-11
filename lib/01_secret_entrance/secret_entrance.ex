defmodule SecretEntrance do
  @moduledoc """
  Calculates the password to the secret entrance by counting zeroes on a dial.
    - numbers go from 0 to 99
    - dial starts at 50
    - R increments dial
    - L decrements dial
  """

  @doc """
  Counts zeros on the dial based on the specified counting mode.

  ## Parameters
  - `mode`:
    - `:at_zero` counts when dial points at 0 *after* a rotation
    - `:past_zero` counts every time dial passes through 0 *during or after* a rotation
  - `path`: file path containing rotation instructions
  - `dial`: starting dial position (default: 50)
  - `count`: starting count (default: 0)
  """
  def count_zeros(mode, path, dial \\ 50, count \\ 0) do
    File.stream!(path, [:trim_bom, encoding: :utf8])
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({dial, count}, fn line, {dial, count} ->
      parse_line(line, dial, count, mode)
    end)
    |> elem(1)
  end

  defp parse_line(line, dial, count, counting_mode) do
    {direction, number} = String.split_at(line, 1)
    value = String.to_integer(number)

    new_dial = calculate_new_dial(value, direction, dial)

    {
      new_dial,
      case counting_mode do
        :at_zero -> increment_if_zero(count, new_dial)
        :past_zero -> calculate_rotations(direction, dial, value) + count
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
