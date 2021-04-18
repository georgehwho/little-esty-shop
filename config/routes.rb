Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#welcome'

  resources :merchants, only: [:show, :create] do
    member do
      get :dashboard
    end
    scope module: :merchants do
      resources :invoices, only: [:show, :index]
      resources :items, only: [:index, :show]
    end
  end



  namespace :admin do
    resources :invoices
    resources :merchants do
      member do
        patch :toggle_enabled
      end
    end
  end

  resources :admin, only: [:index]
end
