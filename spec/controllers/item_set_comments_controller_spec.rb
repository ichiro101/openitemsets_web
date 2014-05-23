require 'spec_helper'

describe ItemSetCommentsController do

  before(:each) do
    @item_set = FactoryGirl.create(:item_set)
    @user = FactoryGirl.create(:user, :username => "Rylai", :email => "Rylai@example.com")
  end

  describe "create" do
    context "with no credentials" do
      before(:each) do
        post :create, :item_set_id => @item_set.id, :item_set_comment => {:comment => "This is a test"}
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do

      before(:each) do
        login(@user)
        post :create, :item_set_id => @item_set.id, :item_set_comment => {:comment => "This is a test"}
      end

      it "should redirect the user to item set" do
        response.should redirect_to(item_set_path(@item_set))
      end

      it "should create an item set comment under item sets" do
        @item_set.item_set_comments.count.should > 0
      end

    end # context

  end #describe

  describe "update" do
    before(:each) do
      @item_set_comment = FactoryGirl.create(:item_set_comment,
                                             :user => @user,
                                             :item_set => @item_set,
                                             :comment => "before comment")
    end

    context "with no credentials" do
      before(:each) do
        put :update, :id => @item_set_comment.id,
          :item_set_id => @item_set.id, 
          :item_set_comment => {:comment => "This is a test"}
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do

      before(:each) do
        login(@user)

        put :update, :id => @item_set_comment.id,
          :item_set_id => @item_set.id, 
          :item_set_comment => {:comment => "after comment"}
      end

      it "should redirect the user to item set" do
        response.should redirect_to(item_set_path(@item_set))
      end

      it "should update the comment" do
        ItemSetComment.find(@item_set_comment.id).comment.should == "after comment"
      end

    end # context

    context "with incorrect credentials" do
      before(:each) do
        @another_user = FactoryGirl.create(:user, :username => "Teemo", :email => "Teemo@example.com")

        login(@another_user)
        put :update, :id => @item_set_comment.id,
          :item_set_id => @item_set.id, 
          :item_set_comment => {:comment => "after comment"}
      end

      it "should redirect the user to item set" do
        response.should redirect_to(item_set_path(@item_set))
      end

      it "should not update the comment" do
        ItemSetComment.find(@item_set_comment.id).comment.should == "before comment"
      end
    end
  end

  describe "destroy" do
    before(:each) do
      @item_set_comment = FactoryGirl.create(:item_set_comment,
                                             :user => @user,
                                             :item_set => @item_set,
                                             :comment => "before comment")
    end

    context "with no credentials" do
      before(:each) do
        delete :destroy, :id => @item_set_comment.id,
          :item_set_id => @item_set.id
      end

      it_behaves_like "require authentication"
    end

    context "with proper credentials" do

      before(:each) do
        login(@user)

        delete :destroy, :id => @item_set_comment.id,
          :item_set_id => @item_set.id
      end

      it "should redirect the user to item set" do
        response.should redirect_to(item_set_path(@item_set))
      end

      it "should delete the comment" do
        @item_set.item_set_comments.count.should == 0

        ItemSet.count.should > 0
      end

    end # context

    context "with incorrect credentials" do
      before(:each) do
        @another_user = FactoryGirl.create(:user, :username => "Teemo", :email => "Teemo@example.com")

        login(@another_user)
        delete :destroy, :id => @item_set_comment.id,
          :item_set_id => @item_set.id
      end

      it "should redirect the user to item set" do
        response.should redirect_to(item_set_path(@item_set))
      end

      it "should not delete the comment" do
        @item_set.item_set_comments.count.should == 1
      end
    end
  end

end
