Rails.application.routes.draw do
  # Magic link routes (before devise so /auth/login maps here)
  scope "auth" do
    get  "login",              to: "users/magic_links#new",     as: :magic_link_login
    post "login",              to: "users/magic_links#create"
    get  "magic_link/sent",    to: "users/magic_links#sent",    as: :magic_link_sent
    post "magic_link/resend",  to: "users/magic_links#resend",  as: :resend_magic_link
    get  "magic_link/verify",  to: "users/magic_links#verify",  as: :verify_magic_link
    get  "magic_link/expired", to: "users/magic_links#expired",  as: :magic_link_expired
  end

  devise_for :users, path: "auth", path_names: {
    sign_in: "password_login", sign_out: "logout", sign_up: "signup"
  }, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :purchase_orders, only: [ :index ]
  resources :items, only: [ :index, :new, :create, :show ]
  resources :suppliers, only: [ :index, :new, :create ]
  resources :members, only: [ :index, :new, :create, :update, :destroy ] do
    member do
      post :reinvite
    end
  end

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

  # 未ログイン: サインアップ画面, ログイン済: 発注一覧
  authenticated :user do
    root "purchase_orders#index", as: :authenticated_root
  end
  root "devise/registrations#new"
end
