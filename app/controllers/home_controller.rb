class HomeController < ApplicationController

  def index
    if signed_in?
      redirect_to item_sets_path
    end
  end

  def install
    @version = "0.0.2b"
  end

end
