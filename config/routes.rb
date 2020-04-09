Rails.application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites
  end

  resources :users
  get "signup" => "users#new"
  resource :session, only: [:new, :create, :destroy]
  get "signin" => "sessions#new"

  resources :genres

  get "movies/filter/:filter" => "movies#index", as: :filtered_movies
end
