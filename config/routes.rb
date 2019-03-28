Rails.application.routes.draw do
  post '/file' => 'resource#create'
  get '/files' => 'resource#index'
  get '/files/:filter/:page' => 'resource#index'
  get '/files/new' => 'resource#new'

  root :to => "resource#index"
end
