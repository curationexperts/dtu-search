Dtu::Application.routes.draw do
  Blacklight.add_routes(self)

  root :to => "catalog#index"

  devise_for :users
  resources :advanced, :as => :advanced_searches

end
