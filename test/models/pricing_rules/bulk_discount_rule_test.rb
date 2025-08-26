require 'test_helper'

class BulkDiscountRuleTest < ActiveSupport::TestCase
  setup do
    @strawberries = products(:strawberries)
  end

  test 'applies bulk discount for 3 or more strawberries' do
    cart_item = CartItem.new(@strawberries.id, 3)
    cart_item.product = @strawberries
    breakdown = [
      { item: cart_item, discount: 0, final_price: @strawberries.price * 3 }
    ]

    PricingRules::BulkDiscountRule.apply!(breakdown)

    assert_equal((@strawberries.price - 4.50) * 3, breakdown.first[:discount].round(2))
    assert_equal 4.50 * 3, breakdown.first[:final_price].round(2)
  end

  test 'applies bulk discount for more than 3 strawberries' do
    cart_item = CartItem.new(@strawberries.id, 4)
    cart_item.product = @strawberries
    breakdown = [
      { item: cart_item, discount: 0, final_price: @strawberries.price * 4 }
    ]

    PricingRules::BulkDiscountRule.apply!(breakdown)

    assert_equal((@strawberries.price - 4.50) * 4, breakdown.first[:discount].round(2))
    assert_equal 4.50 * 4, breakdown.first[:final_price].round(2)
  end

  test 'does not apply discount for less than 3 strawberries' do
    cart_item = CartItem.new(@strawberries.id, 2)
    cart_item.product = @strawberries
    breakdown = [
      { item: cart_item, discount: 0, final_price: @strawberries.price * 2 }
    ]

    PricingRules::BulkDiscountRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal @strawberries.price * 2, breakdown.first[:final_price]
  end

  test 'does not apply discount for other products' do
    green_tea = products(:green_tea)
    cart_item = CartItem.new(green_tea.id, 3)
    cart_item.product = green_tea
    breakdown = [
      { item: cart_item, discount: 0, final_price: green_tea.price * 3 }
    ]

    PricingRules::BulkDiscountRule.apply!(breakdown)

    assert_equal 0, breakdown.first[:discount]
    assert_equal green_tea.price * 3, breakdown.first[:final_price]
  end
end
