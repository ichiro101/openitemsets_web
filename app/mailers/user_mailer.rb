class UserMailer < ActionMailer::Base
  default from: "support@openitemsets.com"

  def confirm_email(user)
    @user = user
    @url = email_confirm_users_path(:token => @user.email_confirmation_token, :host => "http://www.openitemsets.com", :only_path => false)
    mail(:to => @user.email, :subject => "Please confirm your Open Item Sets email address")
  end

end
