BackEndChallenge001::Application.routes.draw do
  resources :guests, param: :name, except: [:destroy, :edit, :new] do
    get 'history', on: :member
  end
end
