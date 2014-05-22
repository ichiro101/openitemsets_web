module UsersHelper

  def gravatar_for(user)
    gravatar_image_tag(user.email, :alt => user.display_name)
  end


  def mini_gravatar_for(user)
    gravatar_image_tag(user.email, :alt => user.display_name, :gravatar => { :size => 15 })
  end
end
