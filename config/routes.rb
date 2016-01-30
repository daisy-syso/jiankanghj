Rails.application.routes.draw do

  namespace :frontend, path: '/' do
    resources :information do
      collection do
        get 'more_information'
      end

      member do
        post 'comment'
      end
    end

    get '/information_list', to: "information#information_list"

    resources :video_category do
      resources :videos do
        collection do
          get 'more_videos'
        end
      end
    end
    
    get '/', to: "information#index"

    get '/users/mine', to: "users#mine"

    get '/users/follow', to: "users#follow"
    get '/users/delete_follow', to: "users#delete_follow"

    get '/users/following_list', to: "users#following_list"

    devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", confirmations: "users/confirmations" }

  end

  # resources :videos
  # resources :video_categories
  
end
