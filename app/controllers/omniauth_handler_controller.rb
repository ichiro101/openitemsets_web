class OmniauthHandlerController < ApplicationController

  def handle_google
    name = auth_hash[:info][:name]
    email = auth_hash[:info][:email]

    user = User.new
    user.username = name
    user.email = email
    user.email_confirmed = true
    user.password = "hello world"
    if user.save
      goto_return_url_or_root
    else
      raise Exception
    end

  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

end
