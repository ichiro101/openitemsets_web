class ClientApiController < ApplicationController

  def get_user
    query = params[:query]
    user = User.where(:username => query).first

    if user.blank?
      user = User.where(:email => query).first
    end

    if user.blank?
      render :text => 'error: user not found'
    end

    render :text => user.id
  end

  def get_user_hash
    user = User.where(:id => params[:query]).first

    if user.blank?
      render :text => 'error: user not found'
      return
    end

    render :text => user.subscription_hash
  end

end
