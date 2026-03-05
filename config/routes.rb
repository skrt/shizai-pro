Rails.application.routes.draw do
  resources :purchase_orders, only: [ :index ]

  # Mockup routes (design review)
  namespace :mockups do
    get  "auth/signup",         to: "auth#signup",              as: :auth_signup
    post "auth/signup",         to: "auth#create_signup"
    get  "auth/password_login", to: "auth#password_login",      as: :auth_password_login
    post "auth/password_login", to: "auth#create_password_login"
    get  "auth/login",          to: "auth#login",               as: :auth_login
    post "auth/login",          to: "auth#create_login"
    get  "auth/sent",           to: "auth#sent",                as: :auth_sent
    post "auth/resend",         to: "auth#resend",              as: :auth_resend
    get  "auth/expired",        to: "auth#expired",             as: :auth_expired
    get  "auth/url_expired",    to: "auth#url_expired",         as: :auth_url_expired
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "purchase_orders#index"
end
