Rails.application.routes.draw do
  resources :categories

  resources :couples, except: :show
  namespace :couples do
    get 'members'
  end

  resources :expenses do
    member do
      patch 'restore'
    end
  end

  resources :payments do
    member do
      patch 'restore'
    end
  end

  resources :users, except: :show
  namespace :users do
    get 'profile'
  end

  post '/access_token', to: 'auth#access_token'
end
