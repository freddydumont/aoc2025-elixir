defmodule GiftShopTest do
  use ExUnit.Case
  doctest GiftShop

  test "[Part 1] example input returns the invalid IDs total" do
    assert GiftShop.validate_IDs(:exact_half, "lib/02_gift_shop/input_test.txt") == 1_227_775_554
  end

  test "[Part 1] full input returns the invalid IDs total" do
    assert GiftShop.validate_IDs(:exact_half, "lib/02_gift_shop/input.txt") == 16_793_817_782
  end

  test "[Part 2] example input returns the invalid IDs total" do
    assert GiftShop.validate_IDs(:any_pattern, "lib/02_gift_shop/input_test.txt") == 4_174_379_265
  end

  test "[Part 2] full input returns the invalid IDs total" do
    assert GiftShop.validate_IDs(:any_pattern, "lib/02_gift_shop/input_test.txt") == 0
  end
end
