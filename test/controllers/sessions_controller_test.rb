require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should create session with valid role" do
    get login_path('ceo')
    assert_redirected_to products_path
    assert_equal 'ceo', session[:user_role]
  end

  test "should destroy session" do
    # Set up session first
    get login_path('ceo')
    
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_role]
  end

  test "should reject invalid role" do
    get login_path('invalid_role')
    assert_redirected_to root_path
    assert_nil session[:user_role]
  end
end
