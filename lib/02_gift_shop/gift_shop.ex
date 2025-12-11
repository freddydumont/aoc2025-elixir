defmodule GiftShop do
  @moduledoc """
  Validates IDs in the given ranges.
  - The ranges are separated by commas (,); each range gives its first ID and last ID separated by a dash (-).
  - invalid IDs are any ID which is made only of some sequence of digits repeated twice.
  - no leading 0 in patterns
  """
  require Integer

  def validate_IDs(path) do
    File.read!(path)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn range, sum -> parse_range(range, sum) end)
  end

  # Parses the given range and add invalid IDs to sum
  defp parse_range(range, sum) do
    [first_id, last_id] = String.split(range, "-")
    range_start = String.to_integer(first_id)
    range_stop = String.to_integer(last_id)

    range_start..range_stop
    |> Range.to_list()
    |> Enum.reduce(sum, fn id, sum ->
      as_string = Integer.to_string(id)
      char_count = String.length(as_string)

      if Integer.is_odd(char_count) do
        sum
      else
        {first_part, second_part} = String.split_at(as_string, div(char_count, 2))
        if first_part == second_part, do: sum + id, else: sum
      end
    end)
  end
end
