class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :signed_in?
  helper_method :current_user

  def signed_in?
    !session[:user_id].blank?
  end

  def current_user
    @current_user ||= User.where(:id => session[:user_id]).first
  end

end
