module SpecTestHelper
  def login(user)
    user = User.where(:username => user.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user])
  end
end
