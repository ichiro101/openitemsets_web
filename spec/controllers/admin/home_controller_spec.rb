require 'spec_helper'

describe Admin::HomeController do

  describe "index" do
    def send_request
      get :index
    end

    it_behaves_like "require administrative access"
  end
end
