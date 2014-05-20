class ClientApiController < ApplicationController

  def get_user
    query = params[:query]
    user = User.where(:username => query).first

    if user.blank?
      user = User.where(:email => query).first
    end

    if user.blank?
      render :text => 'error: user not found'
      return
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

  def get_user_subscription
    user = User.where(:id => params[:query]).first

    if user.blank?
      render :text => 'error: user not found'
      return
    end

    item_set_ids = Subscription.where(:user => user).to_a.map {
      |elem| elem.item_set_id
    }
    render :text => item_set_ids
  end

  def get_item_set
    item_set = ItemSet.where(:id => params[:query]).first

    if item_set.blank?
      return :text => 'error: item set not found'
      return
    end

    render :text => item_set.to_game_json
  end

end
