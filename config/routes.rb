Calamp::Application.routes.draw do

  get "errors/jsdisabled"
=begin
  get "activateuser"  => "sessions#activateuser",  :as => "activateuser"
  get "passwordreset" => "sessions#passwordreset", :as => "passwordreset"
  get "resetpassword" => "sessions#resetpassword", :as => "resetpassword"
  post"resetpassword" => "sessions#resetpassword", :as => "resetpassword"
  get "resetingpassword" => "sessions#resetingpassword", :as => "resetingpassword"
  post "resetingpassword" => "sessions#resetingpassword", :as => "resetingpassword"
=end
  resources :password_resets
  resources :sessions

  #resources :sessions, :only => [:new, :create, :destroy]
  get  "logout"   => "sessions#destroy", :as => "logout"
  get  "login"    => "sessions#new",     :as => "login"
  post "login"    => "sessions#create",  :as => "login"


  namespace :admin, defaults: {format: 'html'} do
    resources :users
    resources :devices
    get "activate_user" => "devices#activate_user", :as => "activate_user"
  end
  resources :logs, :only => [:index, :show]

	get "/logout", :to => "sessions#destroy", :as => "logout"
  root :to => "sessions#new"
end
