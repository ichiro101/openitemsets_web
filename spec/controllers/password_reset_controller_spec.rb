require 'spec_helper'

describe PasswordResetController do

  before(:each) do
    @user = FactoryGirl.create(:user, :email => "orianna@example.com", :email_confirmed => true)
  end

  describe "request password reset" do
    before(:each) do
      get "reset_request"
    end

    it "response should be successful" do
      response.should be_successful
    end

    it "should render the correct template" do
      response.should render_template("reset_request")
    end
  end

  describe "send password reset" do

    context "valid inputs" do
      before(:each) do
        get "reset_send", :email => "orianna@example.com"
      end

      it "should redirect back to the main page" do
        response.should redirect_to(root_url)
      end

      it "should set the password reset token" do
        user = User.where(:email => @user.email).first
        user.password_reset_token.should_not be_blank
      end
    end

    context "account with unconfirmed email" do
      before(:each) do
        @unconfirmed = FactoryGirl.create(:user, 
                                          :username => "Teemo",
                                          :email => "teemo@example.com",
                                          :email_confirmed => false)
        get "reset_send", :email => "teemo@example.com"
      end

      it "should redirect back to the main page" do
        response.should redirect_to(root_url)
      end

      it "should not set the password reset token" do
        user = User.where(:email => @user.email).first
        user.password_reset_token.should == nil
      end
    end

    context "unknown account" do
      before(:each) do
        get "reset_send", :email => "teemo@example.com"
      end

      it "should redirect back to the main page" do
        response.should redirect_to(root_url)
      end

    end
  end


  describe "receiving password reset" do

    before(:each) do
      @user.password_reset_token = "Rylai"
      @user.save
    end

    context "with correct reset token" do
      before(:each) do
        get "reset_receive", :token => "Rylai"
      end

      it "should be successful" do
        response.should be_successful
      end

      it "should render the correct template" do
        response.should render_template("reset_receive")
      end
    end

    context "with incorrect reset token" do
      before(:each) do
        get "reset_receive", :token => "Teemo needs a buff"
      end

      it "redirect to the main page" do
        response.should redirect_to(root_url)
      end
    end

  end # describe "receiving password reset"

  describe "perform password reset" do
    before(:each) do
      @user.password_reset_token = "Rylai"
      @user.save
    end

    context "with correct reset token" do
      before(:each) do
        put "reset_change_password", :token => "Rylai", :password => "Freezing Field"
      end

      it "should be redirected" do
        response.should redirect_to(root_url)
      end

      it "should be able to login with the new password" do
        user = User.authenticate(@user.username, "Freezing Field")
        user.should_not be_blank
      end
    end

    context "with incorrect reset token" do
      before(:each) do
        put "reset_change_password", :token => "Teemo", :password => "I love shrooms"
      end

      it "should be redirected" do
        response.should redirect_to(root_url)
      end

      it "should NOT be able to login with the new password" do
        user = User.authenticate(@user.username, "I love shrooms")
        user.should be_blank
      end
    end

  end

end
