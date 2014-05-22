class UsersController < ApplicationController

  before_filter :require_authentication, :only => [:preferences]

  def new
    @page_title = "Sign up"

    @user = User.new
  end

  def create
    @user = User.new

    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    @user.email = params[:user][:email]

    if @user.save
      flash[:success] = "Successfully signed up, signed in as #{@user.username}"
      session[:user_id] = @user.id

      goto_return_url_or_root
    else
      render 'new'
    end
  end

  def profile
    @user = User.where(:id => params[:id]).first
    @page_title = "Profile for #{@user.display_name}"
  end

  def email_confirm
    @user = User.where(:email_confirmation_token => params[:token]).first

    if @user.blank?
      flash[:danger] = "Invalid email confirmation token"
      redirect_to(root_url)
      return
    end

    if @user.email_confirmed
      flash[:danger] = "Email address is already confirmed"
      redirect_to(root_url)
      return
    end

    @user.email_confirmed = true
    if @user.save
      flash[:success] = "Your email address has been confirmed"
      redirect_to(root_url)
    else
      flash[:danger] = "Something went wrong while trying to confirm your email address, please contact us at the forums"
      redirect_to(root_url)
    end
  end

  def preferences
    @user = current_user
    @page_title = "User Preferences"
  end
end
