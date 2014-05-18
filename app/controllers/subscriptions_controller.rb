class SubscriptionsController < ApplicationController
  before_filter :require_authentication

  def create
    @item_set = ItemSet.where(:id => params[:subscription][:item_set_id]).first
    if @item_set.blank?
      # item set needs to exist before we can subscribe to it
      flash[:error] = 'Invalid Request'
      redirect_to root_url
      return
    end

    @subscription = Subscription.create(:user => current_user,
                                      :item_set_id => params[:subscription][:item_set_id])
    
    if @subscription.save
      flash[:success] = 'Subscribed to this item set'
    else
      flash[:error] = 'Error has occured while trying to subscribe to this item set'
    end
    redirect_to item_set_path(@item_set)
  end

  def destroy
    @subscription = Subscription.where(:id => params[:id]).first

    if @subscription.blank?
      # should not be here, but have an error handler just in case
      flash[:error] = 'Invalid subscription record'
      redirect_to root_url
      return
    end

    @subscription.destroy

    flash[:success] = 'Unsubscribed from this item set'
    redirect_to item_sets_path
  end
end
