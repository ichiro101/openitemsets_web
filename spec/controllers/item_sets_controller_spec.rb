require 'spec_helper'

describe ItemSetsController do

  before(:each) do
    @item_set = FactoryGirl.create(:item_set)

    # for testing permissions
    @item_set_user = @item_set.user
    @another_user = FactoryGirl.create(:user, :username => "Izumi Konata", :email => "konachan@example.com")
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
    context "with no credentials" do
      before(:each) do
        get :edit, :id => @item_set.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@item_set_user)
        get :edit, :id => @item_set.id
      end

      it "should render the template with correct user" do
        response.should render_template(:edit)
      end
    end

    context "with incorrect credentials" do
      before(:each) do
        login(@another_user)
        get :edit, :id => @item_set.id
      end

      it "be redirected to the item_set show page" do
        response.should redirect_to(:controller => "item_sets", :action => "show")
      end
    end
  end

  describe "edit_children" do
    context "with no credentials" do
      before(:each) do
        get :edit_children, :id => @item_set.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@item_set_user)
        get :edit_children, :id => @item_set.id
      end

      it "should render the template with correct user" do
        response.should render_template(:edit_children)
      end
    end

    context "with incorrect credentials" do
      before(:each) do
        login(@another_user)
        get :edit_children, :id => @item_set.id
      end

      it "be redirected to the item_set show page" do
        response.should redirect_to(:controller => "item_sets", :action => "show")
      end
    end
  end

  describe "update" do
    context "with no credentials" do
      before(:each) do
        put :update, :id => @item_set.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@item_set_user)
        put :update, :id => @item_set.id, :item_set => {:title => "New Title", :role => "Mid", :visible_to_public => true}
      end

      it "be redirected to the item_set show action" do
        response.should redirect_to(:controller => "item_sets", :action => "show")
      end
      
      it "should update the item_set object" do
        ItemSet.find(@item_set.id).title.should == "New Title"
      end
    end

    context "with incorrect credentials" do
      before(:each) do
        login(@another_user)
        put :update, :id => @item_set.id, :item_set => {:title => "New Title", :role => "Mid", :visible_to_public => true}
      end

      it "be redirected to the item_set show action" do
        response.should redirect_to(:controller => "item_sets", :action => "show")
      end

      it "should not update the item_set object" do
        ItemSet.find(@item_set.id).title.should_not == "New Title"
      end
    end
  end

  describe 'update_json' do
    json_input = {
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
      :associatedMaps => []
    }.to_json

    json_input_2 = {
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
      :associatedMaps => [1]
    }.to_json

    context "with no credentials" do
      before(:each) do
        put :update_json, :id => @item_set.id, :json => json_input
      end

      it_behaves_like "require authentication"
    end

    context 'with incorrect credentials' do
      before(:each) do
        login(@another_user)
        put :update_json, :id => @item_set.id, :json => json_input
      end

      it "respond with permission denied" do
        JSON.parse(response.body)['error'].should_not be_blank
      end
    end

    context 'with correct credentials, using input 1' do
      before(:each) do
        login(@item_set.user)
        put :update_json, :id => @item_set.id, :json => json_input
      end

      it 'should be a successful request' do
        JSON.parse(response.body)['status'].should == 'success'
      end

      it 'should set the json property' do
        ItemSet.find(@item_set.id).item_set_json.should == json_input
      end

      it "should set map related properties" do
        item_set = ItemSet.find(@item_set.id)
        item_set.map_option.should == 1
      end

      it 'should have no errors' do
        item_set = ItemSet.find(@item_set.id)
        item_set.errors.should be_blank
      end
    end

    context 'with correct credentials, using input 2' do
      before(:each) do
        login(@item_set.user)
        put :update_json, :id => @item_set.id, :json => json_input_2
      end

      it 'should be a successful request' do
        JSON.parse(response.body)['status'].should == 'success'
      end

      it 'should set the json property' do
        ItemSet.find(@item_set.id).item_set_json.should == json_input_2
      end

      it "should set map related properties" do
        item_set = ItemSet.find(@item_set.id)
        item_set.map_option.should == 0
        item_set.map.should == 1
      end

      it 'should have no errors' do
        item_set = ItemSet.find(@item_set.id)
        item_set.errors.should be_blank
      end
    end
  end

  describe "destroy" do
    context "with no credentials" do
      before(:each) do
        delete :destroy, :id => @item_set.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do
      before(:each) do
        login(@item_set_user)
        delete :destroy, :id => @item_set.id
      end

      it "be redirected to the item_set index action" do
        response.should redirect_to(:controller => "item_sets", :action => "index")
      end

      it "should destroy the object" do
        ItemSet.count.should == 0
      end
    end

    context "with incorrect credentials" do
      before(:each) do
        login(@another_user)
        delete :destroy, :id => @item_set.id
      end

      it "be redirected to the item_set show action" do
        response.should redirect_to(:controller => "item_sets", :action => "show")
      end

      it "should not destroy the object" do
        ItemSet.count.should == 1
      end
    end
  end


end
