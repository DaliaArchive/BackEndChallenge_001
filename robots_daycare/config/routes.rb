Rails.application.routes.draw do

  resources :robots, only: [:index, :show, :update], defaults: {format: :json} do
    resources :histories, only: [:index]
  end

end
