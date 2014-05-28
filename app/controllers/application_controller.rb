class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :signed_in?
  helper_method :current_user

  rescue_from Exception, :with => :error_handler

  def signed_in?
    if User.where(:id => session[:user_id]).blank?
      # if session[:user_id] is invalid, clear the session
      session[:user_id] = nil
    end
    !session[:user_id].blank?
  end

  def current_user
    @current_user ||= User.where(:id => session[:user_id]).first
  end

  def require_authentication
    if !signed_in?
      flash[:info] = "This action requires you to sign in"
      cookies[:return_to] = request.url
      redirect_to new_session_path
    end
  end

  def goto_return_url_or_root
    return_url = cookies[:return_to]
    cookies[:return_to] = nil
    if !return_url.blank?
      redirect_to return_url
    else
      redirect_to root_url
    end
  end


  def error_handler(exception)
    e = ExceptionRecord.new
    e.class_name = exception.class.to_s
    e.backtrace = exception.backtrace.join('<br>')
    e.message = exception.message
    e.save

    @page_title = "An error has occured"

    render "home/500"
  end

end
