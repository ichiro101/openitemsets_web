class OmniauthHandlerController < ApplicationController

  def handle_google
    name = auth_hash[:info][:name]
    email = auth_hash[:info][:email]

    handle_omniauth(name, email)
  end

  def handle_facebook
    name = auth_hash[:info][:nickname]
    if name.blank?
      name = auth_hash[:info][:name]
    end
    email = auth_hash[:info][:email]

    handle_omniauth(name, email)
  end

  private

  def handle_omniauth(username, email)
    # before we do anything, check if the user_provider record
    # exists, if it does it means the user has used
    # this service to sign in before
    user_provider = UserProvider.where(:uid => auth_hash[:uid],
                                       :provider => auth_hash[:provider]).first

    if !user_provider.blank?
      user = user_provider.user
      flash[:success] = "Signed in as #{user.username}"
      session[:user_id] = user.id
      goto_return_url_or_root
      return
    end

    # if provider record doesn't exist, then continue...

    # check if we already have an account with the same email
    user = User.where(:email => email).first

    if user.blank?
      create_user_record_from_stratch(username, email)
    else
      provider_record = UserProvider.new
      provider_record.user = user
      provider_record.uid = auth_hash[:uid]
      provider_record.provider = auth_hash[:provider]
      if provider_record.save
        # since this does prove the user owns the email account
        user.email_confirmed = true
        user.save

        flash[:success] = "Signed in as #{user.username}"
        session[:user_id] = user.id
        goto_return_url_or_root
      else
        # raise an error to the user
        raise Error::OmniauthError
      end

    end
  end

  def create_user_record_from_stratch(username, email)
    user = User.new
    user.username = username
    user.email = email
    user.email_confirmed = true
    user.password = 64.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join

    if user.save
      provider_record = UserProvider.new
      provider_record.user = user
      provider_record.uid = auth_hash[:uid]
      provider_record.provider = auth_hash[:provider]
      if provider_record.save
        # set the session and then sign the user in
        flash[:success] = "An account has been created for you"
        session[:user_id] = user.id
        goto_return_url_or_root
      else
        # revert the user record changes
        user.destroy

        # raise an error to the user
        raise Error::OmniauthError
      end
    else
      raise Error::OmniauthError
    end
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

end
