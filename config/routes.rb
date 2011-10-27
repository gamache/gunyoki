Gunyoki::Application.routes.draw do

  resources :servers, :only => [:index, :create, :update, :show]

  resources :games, :only => [:index, :create, :show] 

  resources :players, :only => [:index, :create, :update, :show] do
    get :games
    get :authenticate
    post :change_password
  end

  resources :accounts, :only => [:index, :create, :update, :show, :delete]

  resources :clans, :only => [:index, :create, :update, :show] do
    get :games, :to => 'games#index'
    get :players, :to => 'players#index'
  end

  resources :tournaments, :only => [:index, :create, :update, :show]


  root :to => 'application#root'
end
