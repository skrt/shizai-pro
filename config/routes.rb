Rails.application.routes.draw do
  resources :purchase_orders, only: [ :index ]

  get "up" => "rails/health#show", as: :rails_health_check

  root "purchase_orders#index"
end
