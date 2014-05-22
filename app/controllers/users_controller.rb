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
      # send a confirmation email if the user entered an email
      if !@user.email.blank?
        UserMailer.confirm_email(current_user)
      end

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

  def update_email
    @user = current_user

    # do nothing if the email address is the same
    if @user.email == params[:email]
      redirect_to "/users/preferences"
      return
    end

    @user.email = params[:email]
    # once the email has been changed, it needs
    # to be confirmed again
    @user.email_confirmed = false
    @user.set_email_confirmation_token

    if @user.save
      # send a confirmation email
      UserMailer.confirm_email(current_user)

      flash[:success] = "Email address successfully changed. Confirmation Email has been sent, please check your Email inbox."
      redirect_to "/users/preferences"
    else
      flash[:danger] = "Failed to save your new email address"
      redirect_to "/users/preferences"
    end
  end

  def request_password_reset

  end

  def confirm_password_reset
  end


  def preferences
    @user = current_user
    @page_title = "User Preferences"
  end
end
