class SessionsController < ApplicationController

  def create
    @user = User.authenticate(params[:username], params[:password])

    if @user.blank?
      flash.now[:error] = "Invalid username/password combination"
      render 'new'
    else
      session[:user_id] = @user.id
      flash[:success] = "Signed in as #{@user.username}"
      # TODO: return the user to where the user originally was
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have signed out."
    redirect_to root_url
  end

end
