require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should not save product without code" do
    product = Product.new(name: "Test Product", price: 1.00)
    assert_not product.save
  end

  test "should not save product without name" do
    product = Product.new(code: "TEST", price: 1.00)
    assert_not product.save
  end

  test "should not save product without price" do
    product = Product.new(code: "TEST", name: "Test Product")
    assert_not product.save
  end

  test "should save product with valid attributes" do
    product = Product.new(code: "TEST", name: "Test Product", price: 1.00)
    assert product.save
  end

  test "code should be unique" do
    Product.create!(code: "TEST", name: "Test Product", price: 1.00)
    product = Product.new(code: "TEST", name: "Another Product", price: 2.00)
    assert_not product.save
  end

  test "price should be greater than zero" do
    product = Product.new(code: "TEST", name: "Test Product", price: 0)
    assert_not product.save
    
    product.price = -1
    assert_not product.save
  end

  test "should find product by code" do
    product = Product.create!(code: "TEST", name: "Test Product", price: 1.00)
    found = Product.find_by_code("TEST")
    assert_equal product, found
  end
end