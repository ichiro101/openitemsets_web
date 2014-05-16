require 'spec_helper'

describe SessionsController do

  before(:each) do
    @user = FactoryGirl.create(:user, :username => 'Irelia', :password => 'DoesNotNeedNerf')
  end

  describe 'new' do
    before(:each) do
      post :new
    end

    it 'should render the template' do
      response.should render_template('new')
    end
  end

  describe 'create' do
    context 'with incorrect credentials' do
      before(:each) do
        post :create, :username => 'Irelia', :password => 'ShouldBeNerfed'
      end

      it 'should render the new template' do
        response.should render_template('new')
      end
    end

    context 'with correct credentials' do
      before(:each) do
        post :create, :username => 'Irelia', :password => 'DoesNotNeedNerf'
      end

      it 'should redirect the user to root url' do
        response.should redirect_to(root_url)
      end

      it 'should set the user_id session' do
        request.session[:user_id].should == @user.id
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      delete :destroy, :id => 1
    end

    it 'should redirect the user to rool url' do
      response.should redirect_to(root_url)
    end

    it 'should clear user_id session' do
      request.session[:user_id].should be_nil
    end
  end

end
