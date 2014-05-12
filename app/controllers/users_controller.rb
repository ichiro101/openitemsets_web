class UsersController < ApplicationController

  def new
    @page_title = "Sign up"

    @user = User.new
  end

  def create
    @user = User.new

    @user.username = params[:user][:username]
    @user.password = params[:user][:username]
    @user.email = params[:user][:email]

    if @user.save
      flash[:success] = "Successfully signed up, signed in as #{@user.username}"
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render 'new'
    end
  end

end
