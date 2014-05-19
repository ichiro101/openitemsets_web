require 'spec_helper'

describe ClientApiController do

  context 'getting id for a user or email' do
    before(:each) do
      @user = FactoryGirl.create(:user,
                                 :username => 'Orianna',
                                 :email => 'orianna@example.com')
    end

    it 'should return with a user id when querying the username' do
      get 'get_user', :query => 'Orianna'
      response.body.should == @user.id.to_s
    end

    it 'should return with a user id when querying the email' do
      get 'get_user', :query => 'orianna@example.com'
      response.body.should == @user.id.to_s
    end
  end

  context 'getting sha1 hash for content' do
    before(:each) do
      @user = FactoryGirl.create(:user,
                                 :username => 'Orianna',
                                 :email => 'orianna@example.com')
    end

    it 'should return content' do
      get 'get_user_hash', :query => @user.id
      response.body.should_not be_blank
    end

    it 'should return without error' do
      get 'get_user_hash', :query => @user.id
      response.body.start_with?('error').should be_false
    end

    it 'should return different query if a new subscription is added' do
      get 'get_user_hash', :query => @user.id
      hash_one = response.body

      # create the first item set and subscribe the user to it
      item_set_one = FactoryGirl.create(:item_set, :user => @user)
      Subscription.where(:user_id => @user.id).count.should >= 1

      # test the response after the second item set creation
      get 'get_user_hash', :query => @user.id
      hash_two = response.body

      # create the second item set and subscribe the user to it
      item_set_two = FactoryGirl.create(:item_set, :user => @user)
      Subscription.where(:user_id => @user.id).count.should >= 2

      # test the response after the second item set creation
      get 'get_user_hash', :query => @user.id
      hash_three = response.body

      hash_one.should_not == hash_two
      hash_one.should_not == hash_three
      hash_two.should_not == hash_three
    end

    it 'should return the same hash if nothing has been changed' do
      get 'get_user_hash', :query => @user.id
      hash_one = response.body

      get 'get_user_hash', :query => @user.id
      hash_two = response.body

      hash_one.should == hash_two
    end

    it 'another same hash test case, with item sets' do
      # create an item set and subscribe the user to it
      item_set_one = FactoryGirl.create(:item_set, :user => @user)
      Subscription.where(:user_id => @user.id).count.should >= 1

      get 'get_user_hash', :query => @user.id
      hash_one = response.body

      # make a second request
      get 'get_user_hash', :query => @user.id
      hash_two = response.body

      hash_one.should == hash_two
    end
  end
end
