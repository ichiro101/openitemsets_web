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

  root :to => "home#index"

end
