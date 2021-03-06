Rails.application.routes.draw do
  
  mount API, at: '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'

  constraints :subdomain => /^(admin(.*))$/i do
    namespace :backend, path: '/' do
      
      root 'video_categories#index'
      
      resources :video_categories do
        resources :videos
      end

      resources :videos do
        member do
          post 'move'
        end
      end

      resources :editors_session do
        collection do
          get 'login'
          get 'logout'
        end
      end

      resources :editors
    end
  end

  constraints :subdomain => /^(www(.*))$/i do
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

      resources :apps do
        collection do
          get 'more_apps'
        end
      end

      root 'information#index'

      get '/users/mine', to: "users#mine"

      get '/users/follow', to: "users#follow"
      get '/users/delete_follow', to: "users#delete_follow"

      get '/users/following_list', to: "users#following_list"

      devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", confirmations: "users/confirmations" }

    end
  end

  
end
