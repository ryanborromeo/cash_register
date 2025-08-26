require 'test_helper'

class CartItemTest < ActiveSupport::TestCase
  setup do
    @product = products(:green_tea)
  end

  test 'initializes with product_id and default quantity' do
    cart_item = CartItem.new(@product.id)
    assert_equal @product.id, cart_item.product_id
    assert_equal 1, cart_item.quantity
  end

  test 'initializes with specified quantity' do
    cart_item = CartItem.new(@product.id, 5)
    assert_equal 5, cart_item.quantity
  end

  test '#price calculates the total price for the item' do
    cart_item = CartItem.new(@product.id, 2)
    cart_item.product = @product
    assert_equal (@product.price * 2), cart_item.price
  end

  test '#price raises error if product is not loaded' do
    cart_item = CartItem.new(@product.id)
    assert_raises(RuntimeError, 'Product not loaded') do
      cart_item.price
    end
  end

  test '#to_h returns a hash representation' do
    cart_item = CartItem.new(@product.id, 3)
    expected_hash = { 'product_id' => @product.id, 'quantity' => 3 }
    assert_equal expected_hash, cart_item.to_h
  end
end
