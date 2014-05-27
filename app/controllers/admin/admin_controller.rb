class Admin::AdminController < ApplicationController

  before_filter :require_administrator_access
  layout "admin"

  def require_administrator_access
    if !signed_in?
      flash[:danger] = "Unauthorized"
      redirect_to root_url
      return
    end

    if !current_user.admin?
      flash[:danger] = "Unauthorized"
      redirect_to root_url
      return
    end
  end

end
