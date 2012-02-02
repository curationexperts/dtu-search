Dtu::Application.routes.draw do
  Blacklight.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

end
