Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :robots, param: :name do
    member do
        get 'history'
    end
  end
end
