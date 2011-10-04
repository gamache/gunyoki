Gunyoki::Application.routes.draw do
  resources :games, :only => [:index, :create, :show]

  resources :users, :only => [:index, :create, :update, :show] do
    resources :games, :only => [:index]
    resources :stats, :only => [:index]
  end

  root :to => 'application#root'
end
