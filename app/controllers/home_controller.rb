class HomeController < ApplicationController

  def index
    @page_title = "Open Item Sets"
  end

  def install
    @version = "0.0.1"
  end

end
