defmodule SecretEntranceTest do
  use ExUnit.Case
  doctest SecretEntrance

  test "returns the correct count for part 1 limited" do
    assert SecretEntrance.count_zeros(:at_zero, "lib/day1_secret_entrance/inputs/day1_test.txt") ==
             3
  end

  test "returns the correct count for part 1 full" do
    assert SecretEntrance.count_zeros(:at_zero, "lib/day1_secret_entrance/inputs/day1.txt") ==
             1129
  end

  test "returns the correct count for part 2 limited" do
    assert SecretEntrance.count_zeros(:past_zero, "lib/day1_secret_entrance/inputs/day1_test.txt") ==
             6
  end

  test "returns the correct count for part 2 full" do
    assert SecretEntrance.count_zeros(:past_zero, "lib/day1_secret_entrance/inputs/day1.txt") ==
             6638
  end
end
