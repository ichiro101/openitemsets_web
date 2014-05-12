require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  def self.authenticate(username, password)
    @user = User.where(:username => username).first

    if !@user.blank?
      if @user.password == password
        return @user
      end
    end

    false
  end
  
  def password
    @password ||= Password.new(self.hashed_password)
  end

  def password= (new_password)
    @password = Password.create(new_password)
    self.hashed_password = @password
  end

end
