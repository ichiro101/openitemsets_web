require 'spec_helper'

describe UsersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'new' do

    before(:each) do
      get :new
    end

    it 'should render the correct template' do
      response.should render_template('new')
    end

  end

  describe 'create' do

    context 'with valid inputs' do

      before(:each) do
        post :create, :user => {:username => 'Irelia', :password => 'ShouldNotBeNerfed'}
      end

      it 'should redirect to rool url' do
        response.should redirect_to(root_url)
      end

      it 'should have created a user account' do
        User.count.should > 1
      end
    end

    context 'with invalid inupts' do
      before(:each) do
        post :create, :user => {:username => @user.username, :password => 'Kona-Chan'}
      end

      it 'should render the new template' do
        response.should render_template('new')
      end
    end
  end

  describe 'profile' do

    before(:each) do
      get :profile, :id => @user.id
    end

    it 'should render the profile page' do
      response.should render_template('profile')
    end
  end

end
