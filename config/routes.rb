Rails.application.routes.draw do
  get '/robots', to: 'robots#index'
  get '/robots/:name', to: 'robots#show', :as => :robot
end
