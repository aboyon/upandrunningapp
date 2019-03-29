Rails.application.routes.draw do

  resources :files, :as => :files, :only => [:index, :new, :show] do
    collection do
      get '/:filter/:page', :action => 'index'
    end
  end

  post '/file' => 'files#create'
  root :to => "files#index"
end
