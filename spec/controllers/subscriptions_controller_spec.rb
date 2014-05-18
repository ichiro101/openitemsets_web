require 'spec_helper'

describe SubscriptionsController do

  # Subscription controller only have two important actions
  #
  # create and destroy
  #
  # create is for subscribing
  # destroy is for unsubscribing

  describe 'create' do
    before(:each) do
      @user = FactoryGirl.create(:user, :username => 'Rammus')
      @item_set = FactoryGirl.create(:item_set)

      post :create, :subscription => {:user_id => @user.id,
                                      :item_set_id => @item_set.id}
    end

    context "with no credentials" do
      before(:each) do
        post :create, :subscription => {:item_set_id => @user.id}
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@user)
        post :create, :subscription => {:item_set_id => @item_set.id}
      end

      it 'should create the corresponding Subscription object' do
        Subscription.where(:user_id => @user.id, 
                           :item_set_id => @item_set.id).count.should > 0
      end

      it 'should respond with a redirect' do
        response.should redirect_to(item_set_path(@item_set))
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @user = FactoryGirl.create(:user, :username => 'Rammus')
      @item_set = FactoryGirl.create(:item_set)
      @subscription = FactoryGirl.create(:subscription, :user => @user, :item_set => @item_set)
      @subscription_id = @subscription.id
    end

    context "with no credentials" do
      before(:each) do
        delete :destroy, :id => @subscription.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@user)
        delete :destroy, :id => @subscription.id
      end

      it 'should delete the subscription record' do
        Subscription.where(:id => @subscription_id).count.should == 0
      end

      it 'should respond with a redirect' do
        response.should redirect_to(item_sets_path)
      end
    end
  end
end
