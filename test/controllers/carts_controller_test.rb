require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:green_tea)
  end

  test "should add product to cart" do
    post cart_path, params: { product_id: @product.id }

    assert_redirected_to products_path
    assert_equal "#{@product.name} added to cart.", flash[:notice]

    # Verify session data
    cart_data = session[:cart]
    assert_not_nil cart_data
    assert_equal 1, cart_data["items"].size
    assert_equal @product.id, cart_data["items"].first["product_id"]
  end

  test "should handle non-existent product" do
    post cart_path, params: { product_id: 'invalid-id' }

    assert_redirected_to products_path
    assert_equal 'Product not found.', flash[:alert]
  end
end
