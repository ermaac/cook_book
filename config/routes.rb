Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'recipes#index'
  resources :recipes, only: :index do
    post 'search', on: :collection, to: 'recipes#index'
  end
end
