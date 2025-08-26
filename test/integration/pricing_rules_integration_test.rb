require "test_helper"

class PricingRulesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @gr1 = products(:green_tea)
    @sr1 = products(:strawberries)
    @cf1 = products(:coffee)
  end

  test "CEO login and BOGO pricing rules work end-to-end" do
    # Login as CEO
    get login_path('ceo')
    assert_redirected_to products_path
    assert_equal 'ceo', session[:user_role]

    # Add 2 Green Tea products to cart
    post cart_path, params: { product_id: @gr1.id }
    post cart_path, params: { product_id: @gr1.id }

    # View cart and check pricing
    get cart_path
    assert_response :success

    # Verify the cart has role-based pricing applied
    cart = Cart.from_session(session[:cart])
    pricing_result = PricingCalculator.calculate(cart, 'ceo')
    
    # Should get BOGO discount: 2 items but pay for only 1
    assert_equal 3.11, pricing_result[:total].to_f
    assert pricing_result[:total_discount].to_f > 0, "CEO should get BOGO discount"
  end

  test "COO login and bulk discount pricing rules work end-to-end" do
    # Login as COO
    get login_path('coo')
    assert_redirected_to products_path
    assert_equal 'coo', session[:user_role]

    # Add 3 Strawberry products to cart (triggers bulk discount)
    3.times { post cart_path, params: { product_id: @sr1.id } }

    # View cart and check pricing
    get cart_path
    assert_response :success

    # Verify the cart has role-based pricing applied
    cart = Cart.from_session(session[:cart])
    pricing_result = PricingCalculator.calculate(cart, 'coo')
    
    # Should get bulk discount: 3 items at €4.50 each = €13.50
    assert_equal 13.50, pricing_result[:total].to_f
    assert pricing_result[:total_discount].to_f > 0, "COO should get bulk discount"
  end

  test "VP Engineering login and coffee discount pricing rules work end-to-end" do
    # Login as VP Engineering
    get login_path('vp_engineering')
    assert_redirected_to products_path
    assert_equal 'vp_engineering', session[:user_role]

    # Add 3 Coffee products to cart (triggers coffee discount)
    3.times { post cart_path, params: { product_id: @cf1.id } }

    # View cart and check pricing
    get cart_path
    assert_response :success

    # Verify the cart has role-based pricing applied
    cart = Cart.from_session(session[:cart])
    pricing_result = PricingCalculator.calculate(cart, 'vp_engineering')
    
    # Should get 2/3 price discount: 3 * (11.23 * 2/3) = 22.46
    expected_total = 3 * (@cf1.price * 2.0 / 3.0)
    assert_in_delta expected_total, pricing_result[:total].to_f, 0.01
    assert pricing_result[:total_discount].to_f > 0, "VP Engineering should get coffee discount"
  end

  test "user without login gets no discounts" do
    # Don't login - no session role

    # Add products to cart
    post cart_path, params: { product_id: @gr1.id }
    post cart_path, params: { product_id: @gr1.id }

    # View cart
    get cart_path
    assert_response :success

    # Verify no discounts are applied
    cart = Cart.from_session(session[:cart])
    pricing_result = PricingCalculator.calculate(cart, nil)
    
    # Should pay full price: 2 * 3.11 = 6.22
    assert_equal 6.22, pricing_result[:total].to_f
    assert_equal 0, pricing_result[:total_discount].to_f, "No discounts without login"
  end

  test "complex cart with CEO login applies correct discounts" do
    # Login as CEO
    get login_path('ceo')
    assert_equal 'ceo', session[:user_role]

    # Add complex cart: GR1, SR1, GR1, GR1, CF1
    post cart_path, params: { product_id: @gr1.id }
    post cart_path, params: { product_id: @sr1.id }
    post cart_path, params: { product_id: @gr1.id }
    post cart_path, params: { product_id: @gr1.id }
    post cart_path, params: { product_id: @cf1.id }

    # View cart
    get cart_path
    assert_response :success

    # Verify CEO gets BOGO on Green Tea only
    cart = Cart.from_session(session[:cart])
    pricing_result = PricingCalculator.calculate(cart, 'ceo')
    
    # Expected: 2*GR1 + SR1 + CF1 = 2*3.11 + 5.00 + 11.23 = 22.45
    assert_equal 22.45, pricing_result[:total].to_f
    assert pricing_result[:total_discount].to_f > 0, "CEO should get BOGO discount on Green Tea"
  end
end
