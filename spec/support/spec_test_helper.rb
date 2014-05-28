module SpecTestHelper
  def login(user)
    user = User.where(:username => user.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user_id])
  end


  shared_examples "require authentication" do
    it "should be redirected to login" do
      response.should redirect_to(:controller => "sessions", :action => "new")
    end
  end

  shared_examples "require administrative access" do
    before(:each) do
      @admin_user = FactoryGirl.create(:user,
                                       :username => 'Orianna',
                                       :admin => true,
                                       :email => 'orianna@example.com')

      @user = FactoryGirl.create(:user,
                                 :username => 'NormalDude',
                                 :email => 'normal@example.com')
    end

    it "should not allow unauthenticated users" do
      send_request

      response.should redirect_to(root_url)
    end

    it "should not allow normal users" do
      login(@user)
      send_request

      response.should redirect_to(root_url)
    end

    it "should allow administrators" do
      login(@admin_user)
      send_request

      response.should be_successful
    end
  end
end
