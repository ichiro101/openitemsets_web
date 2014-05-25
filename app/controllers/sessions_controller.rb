class SessionsController < ApplicationController

  def create
    if params[:username].blank? or params[:password].blank?
      flash[:danger] = "Username or password field is blank"
      redirect_to new_session_path
      return
    end

    @user = User.authenticate(params[:username], params[:password])

    if @user.blank?
      flash.now[:warning] = "Invalid username/password combination"
      render 'new'
    else
      session[:user_id] = @user.id
      flash[:success] = "Signed in as #{@user.username}"
      goto_return_url_or_root
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have signed out."
    redirect_to root_url
  end

end
