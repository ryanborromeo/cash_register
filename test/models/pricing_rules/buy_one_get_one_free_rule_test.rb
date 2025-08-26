require 'test_helper'

class BuyOneGetOneFreeRuleTest < ActiveSupport::TestCase
  setup do
    @green_tea = products(:green_tea)
  end

  test 'applies BOGO discount for every two green teas' do
    cart_item = CartItem.new(@green_tea.id, 2)
    cart_item.product = @green_tea
    breakdown = [
      { item: cart_item, discount: 0, final_price: @green_tea.price * 2 }
    ]

    PricingRules::BuyOneGetOneFreeRule.apply!(breakdown)

    assert_equal @green_tea.price, breakdown.first[:discount]
    assert_equal @green_tea.price, breakdown.first[:final_price]
  end

  test 'applies BOGO discount correctly for odd number of green teas' do
    cart_item = CartItem.new(@green_tea.id, 3)
    cart_item.product = @green_tea
    breakdown = [
      { item: cart_item, discount: 0, final_price: @green_tea.price * 3 }
    ]

    PricingRules::BuyOneGetOneFreeRule.apply!(breakdown)

    assert_equal @green_tea.price, breakdown.first[:discount]
    assert_equal @green_tea.price * 2, breakdown.first[:final_price]
  end

  test 'does not apply discount for a single green tea' do
    cart_item = CartItem.new(@green_tea.id, 1)
    cart_item.product = @green_tea
    breakdown = [
      { item: cart_item, discount: 0, final_price: @green_tea.price }
    ]

    PricingRules::BuyOneGetOneFreeRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal @green_tea.price, breakdown.first[:final_price]
  end

  test 'does not apply discount for other products' do
    strawberry = products(:strawberries)
    cart_item = CartItem.new(strawberry.id, 2)
    cart_item.product = strawberry
    breakdown = [
      { item: cart_item, discount: 0, final_price: strawberry.price * 2 }
    ]

    PricingRules::BuyOneGetOneFreeRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal strawberry.price * 2, breakdown.first[:final_price]
  end
end
