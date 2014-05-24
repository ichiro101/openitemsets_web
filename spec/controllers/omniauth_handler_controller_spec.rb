require 'spec_helper'

describe OmniauthHandlerController do

  describe "google authentication" do
    
    before(:each) do
      request.env["omniauth.auth"] = {
            :provider => "google_oauth2",
            :uid => "123456789",
            :info => {
                :name => "John Doe",
                :email => "john@company_name.com",
                :first_name => "John",
                :last_name => "Doe",
                :image => "https://lh3.googleusercontent.com/url/photo.jpg"
            },
            :credentials => {
                :token => "token",
                :refresh_token => "another_token",
                :expires_at => 1354920555,
                :expires => true
            },
            :extra => {
                :raw_info => {
                    :sub => "123456789",
                    :email => "user@domain.example.com",
                    :email_verified => true,
                    :name => "John Doe",
                    :given_name => "John",
                    :family_name => "Doe",
                    :profile => "https://plus.google.com/123456789",
                    :picture => "https://lh3.googleusercontent.com/url/photo.jpg",
                    :gender => "male",
                    :birthday => "0000-06-25",
                    :locale => "en",
                    :hd => "company_name.com"
                }
            }
        }
    end

    context "new account" do
      before(:each) do
        get :handle_google
      end

      it "should redirect the user" do
        response.should be_redirect
      end

      it "should create a new account" do
        User.count.should > 0
      end

      it "should create an account with the correct email address and it should be automatically confirmed" do
        user = User.where(:email => "john@company_name.com").first
        user.should_not be_blank
        user.email_confirmed.should == true
      end

      it "should create an user provider record" do
        UserProvider.count.should > 0
      end

      it "should create a user provider record that links with the created user record" do
        user = User.where(:email => "john@company_name.com").first
        user_provider = UserProvider.where(:user_id => user.id).first
        user_provider.should_not be_blank
      end

      it "should sign the user in" do
        user = User.where(:email => "john@company_name.com").first
        session[:user_id].should == user.id
      end
    end # new account

    context "user has an existing account with same email" do
      before(:each) do
        @user = FactoryGirl.create(:user, :email => "john@company_name.com")
        get :handle_google
      end

      it "should redirect the user" do
        response.should be_redirect
      end

      it "should not create a new account" do
        User.count.should == 1
      end

      it "should set the user's email as confirmed" do
        User.find(@user.id).email_confirmed.should == true
      end

      it "should create an user provider record" do
        UserProvider.count.should > 0
      end

      it "should create a user provider record that links with the existing user record" do
        user_provider = UserProvider.where(:user_id => @user.id).first
        user_provider.should_not be_blank
      end

      it "should sign the user in" do
        session[:user_id].should == @user.id
      end
    end

    context "user provider record already exists" do
      before(:each) do
        @user = FactoryGirl.create(:user, :email => "john2@company_name.com")
        @user_provider = FactoryGirl.create(:user_provider,
            :user_id => @user.id,
            :provider => "google_oauth2",
            :uid => "123456789")
        get :handle_google
      end

      it "should not create an extra user record" do
        User.count.should == 1
      end

      it "should not create an extra user provider record" do
        UserProvider.count.should == 1
      end

      it "should sign the user in" do
        session[:user_id].should == @user.id
      end
    end # user provider already exist
  end # handle google

  describe "handle facebook" do
    before(:each) do
      request.env["omniauth.auth"] = {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :nickname => 'jbloggs',
          :email => 'joe@bloggs.com',
          :name => 'Joe Bloggs',
          :first_name => 'Joe',
          :last_name => 'Bloggs',
          :image => 'http://graph.facebook.com/1234567/picture?type=square',
          :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
          :location => 'Palo Alto, California',
          :verified => true
        },
        :credentials => {
          :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
          :expires_at => 1321747205, # when the access token expires (it always will)
          :expires => true # this will always be true
        },
        :extra => {
          :raw_info => {
            :id => '1234567',
            :name => 'Joe Bloggs',
            :first_name => 'Joe',
            :last_name => 'Bloggs',
            :link => 'http://www.facebook.com/jbloggs',
            :username => 'jbloggs',
            :location => { :id => '123456789', :name => 'Palo Alto, California' },
            :gender => 'male',
            :email => 'joe@bloggs.com',
            :timezone => -8,
            :locale => 'en_US',
            :verified => true,
            :updated_time => '2011-11-11T06:21:03+0000'
          }
        }
      }
    end

    context "new account" do
      before(:each) do
        get :handle_facebook
      end

      it "should redirect the user" do
        response.should be_redirect
      end

      it "should create a new account" do
        User.count.should > 0
      end

      it "should create an account with the correct email address and it should be automatically confirmed" do
        user = User.where(:email => "joe@bloggs.com").first
        user.should_not be_blank
        user.email_confirmed.should == true
      end

      it "should create an user provider record" do
        UserProvider.count.should > 0
      end

      it "should create a user provider record that links with the created user record" do
        user = User.where(:email => "joe@bloggs.com").first
        user_provider = UserProvider.where(:user_id => user.id).first
        user_provider.should_not be_blank
      end

      it "should sign the user in" do
        user = User.where(:email => "joe@bloggs.com").first
        session[:user_id].should == user.id
      end
    end # new account

    context "user has an existing account with same email" do
      before(:each) do
        @user = FactoryGirl.create(:user, :email => "joe@bloggs.com")
        get :handle_facebook
      end

      it "should redirect the user" do
        response.should be_redirect
      end

      it "should not create a new account" do
        User.count.should == 1
      end

      it "should set the user's email as confirmed" do
        User.find(@user.id).email_confirmed.should == true
      end

      it "should create an user provider record" do
        UserProvider.count.should > 0
      end

      it "should create a user provider record that links with the existing user record" do
        user_provider = UserProvider.where(:user_id => @user.id).first
        user_provider.should_not be_blank
      end

      it "should sign the user in" do
        session[:user_id].should == @user.id
      end
    end

    context "user provider record already exists" do
      before(:each) do
        @user = FactoryGirl.create(:user, :email => "joe@bloggs.com")
        @user_provider = FactoryGirl.create(:user_provider,
            :user_id => @user.id,
            :provider => 'facebook',
            :uid => '1234567')
        get :handle_facebook
      end

      it "should not create an extra user record" do
        User.count.should == 1
      end

      it "should not create an extra user provider record" do
        UserProvider.count.should == 1
      end

      it "should sign the user in" do
        session[:user_id].should == @user.id
      end
    end # user provider already exist

  end
end
