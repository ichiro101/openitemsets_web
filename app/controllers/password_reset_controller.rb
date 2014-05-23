class PasswordResetController < ApplicationController

  def reset_send
    user = User.where(:email => params[:email]).first

    if user.blank?
      flash[:danger] = "Account with that Email address not found"
      redirect_to root_url
      return
    end

    if !user.email_confirmed
      flash[:danger] = "Sorry this account's email address has not been confirmed, the password for this account cannot be reset"
      redirect_to root_url
      return
    end

    user.set_password_reset_token
    if !user.save
      flash[:danger] = "Something went wrong while we tried to reset your password, please contact support"
      redirect_to root_url
    end
    
    flash[:success] = "Password reset link has been sent to your email."
    redirect_to root_url
  end

  def reset_receive
    user = User.where(:password_reset_token => params[:token]).first

    if user.blank?
      flash[:danger] = "Invalid password reset token"
      redirect_to root_url
      return
    end
  end

  def reset_change_password
    user = User.where(:password_reset_token => params[:token]).first

    if user.blank?
      flash[:danger] = "Invalid password reset token"
      redirect_to root_url
      return
    end

    user.password = params[:password]
    user.password_reset_token = nil

    if !user.save
      flash[:danger] = "Something went wrong while we tried to reset your password, please contact support"
      redirect_to root_url
    end

    flash[:success] = "Your account password has been successfully reset."
    redirect_to root_url
  end

end
