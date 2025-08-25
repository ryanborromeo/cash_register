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
  rescue_from ActiveRecord::ConnectionNotEstablished, with: :database_unavailable
  rescue_from StandardError, with: :internal_server_error

  def record_not_found
    render_error(404, 'The page you are looking for could not be found.')
  end

  def database_unavailable
    render_error(503, 'Our database is temporarily unavailable. Please try again later.')
  end

  def internal_server_error(exception)
    Rails.logger.error(exception)
    render_error(500, 'An unexpected error occurred. Please try again later.')
  end

  private

  def render_error(status, message)
    render inertia: 'pages/Error', props: { status: status, message: message }, status: status
  end
end
