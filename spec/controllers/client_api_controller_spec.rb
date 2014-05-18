require 'spec_helper'

describe ClientApiController do

  context 'getting id for a user or email' do
    before(:each) do
      @user = FactoryGirl.create(:user,
                                 :username => 'Orianna',
                                 :email => 'orianna@example.com')
    end

    it 'should return with a user id when querying the username' do
      get 'get_user', :query => 'Orianna'
      response.body.should == @user.id.to_s
    end

    it 'should return with a user id when querying the email' do
      get 'get_user', :query => 'orianna@example.com'
      response.body.should == @user.id.to_s
    end
  end

end
