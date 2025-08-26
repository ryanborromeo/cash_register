require 'test_helper'

class PricingCalculatorTest < ActiveSupport::TestCase
  setup do
    @gr1 = products(:green_tea)
    @sr1 = products(:strawberries)
    @cf1 = products(:coffee)
  end

  test 'calculates total for GR1, SR1, GR1, GR1, CF1' do
    cart = Cart.new
    add_products(cart, [@gr1, @sr1, @gr1, @gr1, @cf1])
    assert_equal 22.45, PricingCalculator.calculate(cart)[:total]
  end

  test 'calculates total for GR1, GR1 (BOGO)' do
    cart = Cart.new
    add_products(cart, [@gr1, @gr1])
    assert_equal 3.11, PricingCalculator.calculate(cart)[:total]
  end

  test 'calculates total for SR1, SR1, GR1, SR1 (Bulk Discount)' do
    cart = Cart.new
    add_products(cart, [@sr1, @sr1, @gr1, @sr1])
    assert_equal 16.61, PricingCalculator.calculate(cart)[:total]
  end

  test 'calculates total for GR1, CF1, SR1, CF1, CF1 (Coffee Discount)' do
    cart = Cart.new
    add_products(cart, [@gr1, @cf1, @sr1, @cf1, @cf1])
    assert_equal 30.57, PricingCalculator.calculate(cart)[:total]
  end

  private

  def add_products(cart, products)
    products.each { |product| CartServices::AddProduct.call(cart, product) }
  end
end
