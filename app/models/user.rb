require 'bcrypt'
require 'securerandom'

class User < ActiveRecord::Base
  include BCrypt

  has_many :item_sets

  validates :username, :uniqueness => true, :presence => true
  validates :password, :presence => true
  validates :email, :uniqueness => true

  before_create :set_email_confirmation_token

  def self.authenticate(username, password)
    @user = User.where(:username => username).first

    if @user.blank?
      @user = User.where(:email => username).first
    end

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

  def subscription_hash
    require 'digest/sha1'
    subscriptions = Subscription.where(:user_id => self.id)

    if subscriptions.count == 0
      return 'empty'
    end

    array_to_hash = []

    subscriptions.map do |sub|
      array_to_hash << sub.item_set.item_set_json
    end

    Digest::SHA1.hexdigest(array_to_hash.to_json)
  end

  def display_name
    username
  end

  def set_email_confirmation_token
    self.email_confirmation_token = 64.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
  end

  def set_password_reset_token
    self.password_reset_token = 64.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
  end
end
