class SessionsController < ApplicationController

  def new
    @page_title = "Sign in"
  end

  def create
    @user = User.authenticate(params[:username], params[:password])

    if @user.blank?
      flash.now[:warning] = "Invalid username/password combination"
      render 'new'
    else
      session[:user_id] = @user.id
      flash[:success] = "Signed in as #{@user.username}"
      if !cookies[:return_to].blank?
        redirect_to cookies[:return_to]
      else
        redirect_to root_url
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have signed out."
    redirect_to root_url
  end

end
