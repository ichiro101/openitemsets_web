require 'spec_helper'

describe ItemSetsController do

  before(:each) do
    @item_set = FactoryGirl.create(:item_set)

    # for testing permissions
    @item_set_user = @item_set.user
    @another_user = FactoryGirl.create(:user, :username => "Izumi Konata")
  end

  describe "index" do
    before(:each) do
      get :index
    end

    it "should render the index template" do
      response.should render_template(:index)
    end
  end

  describe "show" do
    before(:each) do
      get :show, :id => @item_set.id
    end

    it "should render the show template" do
      response.should render_template(:show)
    end
  end

  describe "edit" do
    before(:each) do
      login(@item_set_user)
      get :edit, :id => @item_set.id
    end

    it "should render the template with correct user" do
      response.should render_template(:edit)
    end
  end

end
