Rails.application.routes.draw do

  resources :item_sets do
    member do
      get :edit_children
      put :update_json
    end
  end
  resources :users do
    member do
      get :profile
    end
  end
  resources :sessions
  resources :subscriptions

  # api routes
  scope '/api' do
    get 'get_user', :to => 'client_api#get_user'
    get 'get_user_hash', :to => 'client_api#get_user_hash'
  end

  root :to => "home#index"

end
