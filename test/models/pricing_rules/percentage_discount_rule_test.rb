require 'test_helper'

class PercentageDiscountRuleTest < ActiveSupport::TestCase
  setup do
    @coffee = products(:coffee)
  end

  test 'applies percentage discount for 3 or more coffees' do
    original_price = @coffee.price * 3
    cart_item = CartItem.new(@coffee.id, 3)
    cart_item.product = @coffee
    breakdown = [
      { item: cart_item, discount: 0, final_price: original_price, original_price: original_price }
    ]

    PricingRules::PercentageDiscountRule.apply!(breakdown)

    expected_discount = (original_price * (1.0 / 3.0)).round(2)
    assert_equal expected_discount, breakdown.first[:discount].round(2)
    assert_equal (original_price - expected_discount), breakdown.first[:final_price].round(2)
  end

  test 'applies percentage discount for more than 3 coffees' do
    original_price = @coffee.price * 4
    cart_item = CartItem.new(@coffee.id, 4)
    cart_item.product = @coffee
    breakdown = [
      { item: cart_item, discount: 0, final_price: original_price, original_price: original_price }
    ]

    PricingRules::PercentageDiscountRule.apply!(breakdown)

    expected_discount = (original_price * (1.0 / 3.0)).round(2)
    assert_equal expected_discount, breakdown.first[:discount].round(2)
    assert_equal (original_price - expected_discount), breakdown.first[:final_price].round(2)
  end

  test 'does not apply discount for less than 3 coffees' do
    original_price = @coffee.price * 2
    cart_item = CartItem.new(@coffee.id, 2)
    cart_item.product = @coffee
    breakdown = [
      { item: cart_item, discount: 0, final_price: original_price, original_price: original_price }
    ]

    PricingRules::PercentageDiscountRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal original_price, breakdown.first[:final_price]
  end

  test 'does not apply discount for other products' do
    green_tea = products(:green_tea)
    original_price = green_tea.price * 3
    cart_item = CartItem.new(green_tea.id, 3)
    cart_item.product = green_tea
    breakdown = [
      { item: cart_item, discount: 0, final_price: original_price, original_price: original_price }
    ]

    PricingRules::PercentageDiscountRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal original_price, breakdown.first[:final_price]
  end
end
