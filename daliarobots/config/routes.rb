Daliarobots::Application.routes.draw do

  root :to => "robots#index"

  get "robots", to: "robots#index"

  get "robots/:name", to: "robots#show"

  put "robots/update/", to: "robots#update"

  get "robots/:name/history", to: "robots#history"
  
end
