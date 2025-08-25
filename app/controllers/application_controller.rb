class ApplicationController < ActionController::Base
  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= Cart.from_session(session[:cart])
  end

  def save_cart
    session[:cart] = current_cart.to_session
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    redirect_to root_path, alert: "Record not found."
  end
end
