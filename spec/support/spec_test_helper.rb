module SpecTestHelper
  def login(user)
    user = User.where(:username => user.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user])
  end


  shared_examples "require authentication" do
    it "should be redirected to login" do
      response.should redirect_to(:controller => "sessions", :action => "new")
    end
  end
end
