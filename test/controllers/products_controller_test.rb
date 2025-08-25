require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should load all products ordered by code" do
    products = Product.all.order(:code)
    assert_equal 3, products.count
    assert_equal "CF1", products.first.code
    assert_equal "GR1", products.second.code
    assert_equal "SR1", products.third.code
  end

  test "should have correct product data" do
    green_tea = Product.find_by(code: "GR1")
    strawberries = Product.find_by(code: "SR1") 
    coffee = Product.find_by(code: "CF1")
    
    assert_equal "Green tea", green_tea.name
    assert_equal 3.11, green_tea.price
    
    assert_equal "Strawberries", strawberries.name
    assert_equal 5.00, strawberries.price
    
    assert_equal "Coffee", coffee.name
    assert_equal 11.23, coffee.price
  end
end