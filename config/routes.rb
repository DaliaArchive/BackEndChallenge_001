Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :robots, only: [:index, :show, :update] do
    resources :histories, only: [:index]
  end
end
