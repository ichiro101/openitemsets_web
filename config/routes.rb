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
      put :update_email
    end

    collection do
      get :email_confirm
      get :preferences
      get :resend
    end
  end

  resources :sessions
  resources :subscriptions

  # password reset routes
  get '/password_reset/reset_request', :to => 'password_reset#reset_request'
  get '/password_reset/reset_send', :to => 'password_reset#reset_send'
  get '/password_reset/reset_receive', :to => 'password_reset#reset_receive'
  put '/password_reset/reset_change_password', :to => 'password_reset#reset_change_password'

  # api routes
  scope '/api' do
    get 'get_user', :to => 'client_api#get_user'
    get 'get_user_hash', :to => 'client_api#get_user_hash'
    get 'get_user_subscription', :to => 'client_api#get_user_subscription'
    get 'get_item_set', :to => 'client_api#get_item_set'
  end

  get '/install', :to => 'home#install'
  get '/tos', :to => 'home#tos'
  get '/privacy', :to => 'home#privacy'
  get '/about_us', :to => 'home#about_us'
  root :to => "home#index"

end
