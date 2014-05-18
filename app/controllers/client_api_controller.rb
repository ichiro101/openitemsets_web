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

end
