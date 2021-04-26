Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#welcome'

  resources :merchants, only: [:show, :create] do
    scope module: :merchants do
      resources :bulk_discounts
      resources :dashboard, only: [:index]
      resources :invoices, only: [:show, :index, :update]
      resources :items do
        member do
          patch :toggle_enabled
        end
      end
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
