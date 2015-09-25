require 'route_constraints/root_domain'
require 'route_constraints/subdomain'
require 'sidekiq/web'

Rails.application.routes.draw do

  # Clearance routes for authentication
  resources :passwords,
    controller: 'reset_passwords',
    only: [:create, :new]

  resource :session,
    controller: 'clearance/sessions',
    only: [:create]

  resources :users,
    controller: 'clearance/users',
    only: Clearance.configuration.user_actions do
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  # end Clearance routes

  constraints(RouteConstraints::RootDomain) do
    resources :signups, only: [:new, :create] do
      get "success", on: :collection
    end

    get "/settings", to: redirect('/settings/account/edit'), as: :settings
    namespace :settings do
      resource :password, only: [:show, :create]
      resource :account, only: [:edit, :update, :destroy], controller: :account do
        get "delete"
      end
      resources :teams, only: [:show, :new, :create, :update] do
        delete "leave", on: :member
      end
    end
  end # root domain constraint

  constraints(RouteConstraints::Subdomain) do
    get "/" => "projects#index"

    # First time setup flow
    get "/setup/start/:code", to: "setup#index", as: :setup
    put "/setup/user", to: "setup#update_user", as: :setup_user
    get "/setup/first_project", to: "setup#first_project", as: :setup_first_project
    post "/setup/first_project", to: "setup#create_project"
    get "/setup/invite_team", to: "setup#invite_team", as: :setup_invite_team
    post "/setup/invite_team", to: "setup#send_invites"

    resources :files, only: :index
    resources :team, only: [:index, :show]
    resources :team_invites, only: [:new, :create, :edit, :update]
    resources :search, only: :index

    resources :projects do
      get "archived", on: :collection
      get "restore", on: :member
      resources :stories do
        get "archived", on: :collection
        get "restore", on: :member
        resources :comments
        resources :tasks do
          put "update-order", on: :collection
        end
        resources :attachments
      end
    end

  end # subdomain constraint

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Dynamic error pages
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  root to: "public#index"
  get "help", to: "public#help"

end
