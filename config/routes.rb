Rails.application.routes.draw do

  resources :item_sets do
    member do
      get :edit_children
    end
  end
  resources :users do
    member do
      get :profile
    end
  end
  resources :sessions

  root :to => "home#index"

end
