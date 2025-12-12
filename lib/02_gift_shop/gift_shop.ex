defmodule GiftShop do
  @moduledoc """
  Validates IDs in the given ranges.
  - The ranges are separated by commas (,); each range gives its first ID and last ID separated by a dash (-).
  - provided IDs do not have leading 0
  - invalid IDs are any ID which include a repeated sequence of digits
    - when mode is `:exact_half`: repeated *exactly* twice
    - when mode is `:any_pattern`: repeated *at least* twice
  """
  require Integer

  def validate_IDs(mode, path) do
    path
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn range, sum -> parse_range(range, sum, mode) end)
  end

  # Parses the given range and add invalid IDs to sum
  defp parse_range(range, sum, mode) do
    [first_id, last_id] = String.split(range, "-")
    range_start = String.to_integer(first_id)
    range_stop = String.to_integer(last_id)

    range_start..range_stop
    |> Range.to_list()
    |> Enum.reduce(sum, fn id, sum ->
      as_string = Integer.to_string(id)
      char_count = String.length(as_string)

      case mode do
        :exact_half ->
          if Integer.is_odd(char_count) do
            sum
          else
            {first_part, second_part} = String.split_at(as_string, div(char_count, 2))
            if first_part == second_part, do: sum + id, else: sum
          end

        :any_pattern ->
          # todo: this repeats the same check for all IDs, but consecutive numbers will all be validated by the same check

          if Enum.any?(1..div(char_count, 2)//1, fn pattern_size ->
               if rem(char_count, pattern_size) == 0 do
                 {pattern, _} = String.split_at(as_string, pattern_size)

                 ~r/(#{pattern}){#{div(char_count, pattern_size)}}/
                 |> Regex.match?(as_string)
               else
                 false
               end
             end) do
            sum + id
          else
            sum
          end
      end
    end)
  end
end
