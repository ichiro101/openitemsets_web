Rails.application.routes.draw do

  resources :item_sets
  resources :users
  resources :sessions

  root :to => "home#index"

end
