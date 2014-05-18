require 'spec_helper'

describe Subscription do
  describe 'as itself' do
    before(:each) do
      @subscription = Subscription.new
      @subscription.user = FactoryGirl.create(:user, :username => 'Rammus')
      @subscription.item_set = FactoryGirl.create(:item_set)
    end

    it 'should save successfully' do
      @subscription.save.should_not be_blank
    end

    it 'should require a user field' do
      @subscription.user = nil
      @subscription.save.should be_blank
    end

    it 'should require item_set field' do
      @subscription.item_set = nil
      @subscription.save.should be_blank
    end

    it 'should not allow two records with the same item_set and user' do
      # save this record first
      @subscription.save.should_not == false

      second_sub = FactoryGirl.build(:subscription,
                                     :user => @subscription.user,
                                     :item_set => @subscription.item_set)

      # this duplicate subscription should fail
      second_sub.save.should == false
    end
  end

  describe 'as it relates to ItemSet' do
    before(:each) do
      @item_set = FactoryGirl.create(:item_set)
    end

    it 'should have at least one subscription autocreated from item set' do
      Subscription.count.should >= 1
    end

    it 'should have a subscription record between item_set and the owner' do
      Subscription.where(:user => @item_set.user, :item_set => @item_set).count.should == 1
    end
  end
end
