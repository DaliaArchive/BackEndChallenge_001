Rails.application.routes.draw do
  get '/robots', to: 'robots#index'
  get '/robots/:name', to: 'robots#show', as: :robot
  put '/robots/:name', to: 'robots#update'
end
