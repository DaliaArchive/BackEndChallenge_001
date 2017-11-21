Rails.application.routes.draw do
  post 'guests/:name', to: 'guests#update'
  get  'guests/:name', to: 'guests#show'
  get  'guests/index', to: 'guests#index'
  get  'guests/history/:name', to: 'guests#history'
end
