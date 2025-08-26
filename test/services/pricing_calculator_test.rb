require 'test_helper'

class PricingCalculatorTest < ActiveSupport::TestCase
  setup do
    @gr1 = products(:green_tea)
    @sr1 = products(:strawberries)
    @cf1 = products(:coffee)
  end

  test 'calculates total without user role (no discounts)' do
    cart = Cart.new
    add_products(cart, [@gr1, @sr1, @gr1, @gr1, @cf1])
    assert_equal 25.56, PricingCalculator.calculate(cart)[:total].to_f
  end

  test 'CEO gets BOGO on Green Tea' do
    cart = Cart.new
    add_products(cart, [@gr1, @gr1])
    assert_equal 3.11, PricingCalculator.calculate(cart, 'ceo')[:total].to_f
  end

  test 'CEO gets BOGO discount on complex cart' do
    cart = Cart.new
    add_products(cart, [@gr1, @sr1, @gr1, @gr1, @cf1])
    # Original: 3.11 + 5.00 + 3.11 + 3.11 + 11.23 = 25.56
    # CEO discount: 3 GR1s = 2 * 3.11 = 6.22 (instead of 9.33)
    # Total: 6.22 + 5.00 + 11.23 = 22.45
    assert_equal 22.45, PricingCalculator.calculate(cart, 'ceo')[:total].to_f
  end

  test 'COO gets bulk discount on Strawberries' do
    cart = Cart.new
    add_products(cart, [@sr1, @sr1, @gr1, @sr1])
    # 3 SR1s at 4.50 each = 13.50, plus 1 GR1 at 3.11 = 16.61
    assert_equal 16.61, PricingCalculator.calculate(cart, 'coo')[:total].to_f
  end

  test 'VP Engineering gets coffee discount' do
    cart = Cart.new
    add_products(cart, [@gr1, @cf1, @sr1, @cf1, @cf1])
    # 3 CF1s at 2/3 price = 3 * (11.23 * 2/3) = 3 * 7.487 = 22.46
    # Plus GR1 (3.11) and SR1 (5.00) = 30.57
    assert_equal 30.57, PricingCalculator.calculate(cart, 'vp_engineering')[:total].to_f
  end

  private

  def add_products(cart, products)
    products.each { |product| CartServices::AddProduct.call(cart, product) }
  end
end
