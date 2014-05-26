require 'spec_helper'

describe ItemSet do
  before :each do
    @item_set = ItemSet.new
    @item_set.title = "Generic Ahri Build"
    @item_set.champion = "Ahri"
    @item_set.role = "Mid"

  end

  it "should save with valid fields" do
    @item_set.save.should_not be_blank
  end

  it "should should not save with invalid role" do
    @item_set.role = "Troll"
    @item_set.save.should be_blank
  end

  it "should should not save with invalid champion" do
    @item_set.champion = "Konata Izumi"
    @item_set.save.should be_blank
  end

  it "should delete all subscriptions once the record is destroyed" do
    Subscription.count.should == 0
    user = FactoryGirl.create(:user, :username => "some user", :email => "anyuser@example.com")
    item_set = FactoryGirl.create(:item_set, :user => user)
    Subscription.count.should == 1
    item_set.destroy
    Subscription.count.should == 0
  end

  describe 'json test' do
    before :each do
      @json_input_1 = {
        :blocks => [
          {
            :items => [
              {
                :count => 1,
                :id => 2003
              },
              {
                :count => 1,
                :id => 2004
              }
            ],
            :type => "Consumable"
          },
          {
            :items => [
              {
                :count => 1,
                :id => 1056
              }
            ],
            :type => "Starting Items"
          }
        ],
        :map => "any",
        :associatedMaps => []
      }.to_json

      @json_input_2 = {
        :blocks => [
          {
            :items => [
              {
                :count => 1,
                :id => 2003
              },
              {
                :count => 1,
                :id => 2004
              }
            ],
            :type => "Consumable"
          },
          {
            :items => [
              {
                :count => 1,
                :id => 1056
              }
            ],
            :type => "Starting Items"
          }
        ],
        :map => "any",
        :associatedMaps => [1]
      }.to_json
    end

    it 'should be able to save first json input' do
      @item_set.item_set_json = @json_input_1
      @item_set.save.should_not be_blank
    end

    it 'should be able to save second json input' do
      @item_set.item_set_json = @json_input_2
      @item_set.save.should_not be_blank
    end

    it 'should output a game readable json' do
      @item_set.item_set_json = @json_input_1
      @item_set.save

      output_json = {
        :blocks => [
          {
            :items => [
              {
                :count => 1,
                :id => "2003"
              },
              {
                :count => 1,
                :id => "2004"
              }
            ],
            :type => "Consumable"
          },
          {
            :items => [
              {
                :count => 1,
                :id => "1056"
              }
            ],
            :type => "Starting Items"
          }
        ],
        :map => "any",
        :associatedMaps => [],
        :mode => 'any',
        :title => @item_set.display_name,
        :sortrank => 1,
        :isGlobalForMaps => true,
        :isGlobalForChampions => false,
        :champion => @item_set.champion,
        :type => "custom",
        :priority => false
      }.to_json

      @item_set.to_game_json.should == output_json
    end
  end

  context "testing limits (this will take a while)" do
    before(:each) do
      @user = FactoryGirl.create(:user, :username => "heavy user", :email => "heavy_user@example.com")
    end

    it "should limit the ownership" do
      ItemSet::OWNERSHIP_LIMIT.times do
        FactoryGirl.create(:item_set, :user_id => @user.id)
      end

      ItemSet.where(:user_id => @user.id).count.should == ItemSet::OWNERSHIP_LIMIT

      another_item_set = FactoryGirl.build(:item_set, :user_id => @user.id)
      another_item_set.save.should be_false
    end

    it "should limit the number of subscriptions" do
      # set up all the item sets
      some_random_user = FactoryGirl.create(:user,
                                            :username => "corki",
                                            :email => "corki@example.com")
      another_user = FactoryGirl.create(:user,
                                        :username => "anotheruser",
                                        :email => "anotheruser@example.com")

      ItemSet::SUBSCRIPTION_LIMIT.times do
        item_set = FactoryGirl.create(:item_set, :user_id => some_random_user.id)

        # subscribe the user to the item set
        FactoryGirl.create(:subscription, :item_set_id => item_set.id, :user_id => @user.id)
      end

      # create another item set for subscription
      another_item_set = FactoryGirl.build(:item_set, :user_id => another_user.id)
      another_item_set.save.should_not be_false

      # should not be able to subscribe another item set
      another_subscription = FactoryGirl.build(:subscription, :item_set_id => another_item_set.id,
                                               :user_id => @user.id)
      another_subscription.save.should be_false
    end
  end
end
