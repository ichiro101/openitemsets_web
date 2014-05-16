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
