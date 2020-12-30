Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :users, only: [:show, :edit, :update]
  resources :events, only: [:new, :create, :show]
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
end
