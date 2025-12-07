defmodule SecretEntranceTest do
  use ExUnit.Case
  doctest SecretEntrance

  test "returns the correct count" do
    assert SecretEntrance.count_dial_at_zero("lib/day1_secret_entrance/inputs/day1_test.txt") == 3
  end
end
