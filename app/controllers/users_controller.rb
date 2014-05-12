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

      goto_return_url_or_root
    else
      render 'new'
    end
  end

end
