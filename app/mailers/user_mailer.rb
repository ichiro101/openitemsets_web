class UserMailer < ActionMailer::Base
  default from: "support@openitemsets.com"

  def confirm_email(user)
    @user = user
    @url = email_confirm_users_path(:token => @user.email_confirmation_token, :host => "http://www.openitemsets.com", :only_path => false)
    mail(:to => @user.email, :subject => "Please confirm your Open Item Sets email address")
  end

  def reset_password(user)
    @user = user
    @url = password_reset_reset_receive_path(:token => @user.password_reset_token, :host => "http://www.openitemsets.com", :only_path => false)
    mail(:to => @user.email, :subject => "Open Item Sets Password Reset")
  end

end
