Dtu::Application.routes.draw do
  Blacklight.add_routes(self)

  root :to => "welcome#index"

  devise_for :users

end
