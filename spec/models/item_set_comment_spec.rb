require 'spec_helper'

describe ItemSetComment do

  before(:each) do
    @item_set = FactoryGirl.create(:item_set)
    @comment = FactoryGirl.build(:item_set_comment, :item_set => @item_set, :user => @item_set.user)
  end

  it "should be able to create the record" do
    @comment.save.should_not be_blank
  end

end
