Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, defaults: {format: :json}

  namespace :api do
    namespace :v1 do
      resources :bookmarks, only: [:index, :create, :update, :destroy]
      resources :tags, only: [:index, :show]
      resources :taggings, only: [:create, :destroy]
      resources :kits, only: [:index, :create, :destroy]
      resources :kittings, only: [:create, :destroy]
      # delete '/kittings', to: 'kittings#destroy'
      get '/checks', to: 'checks#index'
      get '/checks/starter', to: 'checks#starter'
    end
  end
end
