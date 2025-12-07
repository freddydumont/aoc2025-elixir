defmodule SecretEntranceTest do
  use ExUnit.Case
  doctest SecretEntrance

  test "returns the correct count for part 1" do
    assert SecretEntrance.count_dial_at_zero("lib/day1_secret_entrance/inputs/day1_test.txt") == 3
  end

  test "returns the correct count for part 2" do
    assert SecretEntrance.count_dial_past_zero("lib/day1_secret_entrance/inputs/day1_test.txt") ==
             6
  end
end
