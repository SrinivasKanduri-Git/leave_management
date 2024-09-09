# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :employees do
    member do
      get :leave_requests, to: 'employees#show_lr'
    end
  end
  resources :leave_requests do
    member do
      put :update_apr, to: 'leave_requests#update_status'
      get :view, to: 'leave_requests#view_lr'
    end
  end
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
  # Defines the root path route ("/")
  # root "posts#index"
end
