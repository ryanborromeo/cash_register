require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @product1 = products(:green_tea)
    @product2 = products(:strawberries)
  end

  test "can be initialized" do
    cart = Cart.new
    assert_empty cart.items
    assert_equal 0, cart.total
  end

  test "adds a product" do
    cart = Cart.new
    cart.add_product(@product1)

    assert_equal 1, cart.items.length
    assert_equal @product1.id, cart.items.first.product_id
    assert_equal 1, cart.items.first.quantity
  end

  test "adds multiple products" do
    cart = Cart.new
    cart.add_product(@product1)
    cart.add_product(@product2)

    assert_equal 2, cart.items.length
  end

  test "increments quantity for duplicate products" do
    cart = Cart.new
    cart.add_product(@product1)
    cart.add_product(@product1)

    assert_equal 1, cart.items.length
    assert_equal 2, cart.items.first.quantity
  end

  test "calculates the total price" do
    cart = Cart.new
    cart.add_product(@product1)
    cart.add_product(@product1)
    cart.add_product(@product2)

    expected_total = (@product1.price * 2) + @product2.price
    assert_equal expected_total, cart.total
  end
end
