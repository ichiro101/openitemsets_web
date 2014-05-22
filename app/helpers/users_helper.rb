module UsersHelper

  def gravatar_for(user)
    return gravatar_image_tag(user.email, :alt => user.display_name) if !user.email.blank?
    gravatar_image_tag(user.display_name, :alt => user.display_name)
  end


  def mini_gravatar_for(user)
    return gravatar_image_tag(user.email, :alt => user.display_name, :gravatar => { :size => 15 }) if !user.email.blank?
    gravatar_image_tag(user.display_name, :alt => user.display_name, :gravatar => { :size => 15 })
  end
end
