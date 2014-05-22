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
    item_set = FactoryGirl.create(:item_set)
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
end
