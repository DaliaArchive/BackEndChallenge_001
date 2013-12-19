BackEndChallenge001::Application.routes.draw do
  resources :guests, :param => :name
end
