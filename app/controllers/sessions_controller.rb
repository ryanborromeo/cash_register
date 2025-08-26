class SessionsController < ApplicationController
  def new
    redirect_to root_path
  end

  def create
    role = params[:role] || params[:user_role]
    if User::ROLES.include?(role)
      session[:user_role] = role
      redirect_to products_path, notice: "Logged in as #{User.new(role).display_name}"
    else
      redirect_to root_path, alert: "Invalid role selected"
    end
  end

  def destroy
    session[:user_role] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
