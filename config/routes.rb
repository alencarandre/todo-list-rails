Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :lists, only: [:create, :destroy] do
    resources :tasks, only: [:create, :destroy] do
      post :check
    end
  end

  namespace :lists do
    resources :public, only: [:index]
    resources :mine, only: [:index]
    resources :starred, only: [:index, :destroy]

    post 'starred/:id', to: 'starred#create'
  end

  root 'home#index'
end
