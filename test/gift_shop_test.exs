defmodule GiftShopTest do
  use ExUnit.Case
  doctest GiftShop

  test "example input returns the invalid IDs total" do
    assert GiftShop.validate_IDs("lib/02_gift_shop/input_test.txt") == 1_227_775_554
  end

  test "full input returns the invalid IDs total" do
    assert GiftShop.validate_IDs("lib/02_gift_shop/input.txt") == 16_793_817_782
  end
end
