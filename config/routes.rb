Rails.application.routes.draw do
  root 'books#index'
  devise_for :users 
  resources :books
  resources :users, only: [:index, :show]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
