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

  defp parse_range(range, sum) do
    [first_id, last_id] = String.split(range, "-")
    expanded_range = Range.to_list(String.to_integer(first_id)..String.to_integer(last_id))
    # for each element in expanded_range:
    Enum.reduce(expanded_range, sum, fn id, sum ->
      # convert back to string
      as_string = Integer.to_string(id)
      char_count = String.length(as_string)
      # pass if character count is odd
      if Integer.is_odd(char_count) do
        sum
      else
        # split in two equal parts and check equality
        {first_part, second_part} = String.split_at(as_string, div(char_count, 2))
        # if equal, add id to sum
        if first_part == second_part, do: sum + id, else: sum
      end
    end)
  end
end
