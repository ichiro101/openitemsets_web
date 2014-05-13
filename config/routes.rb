Rails.application.routes.draw do

  resources :item_sets
  resources :users do
    member do
      get :profile
    end
  end
  resources :sessions

  root :to => "home#index"

end
