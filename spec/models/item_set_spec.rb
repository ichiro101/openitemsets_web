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

end
