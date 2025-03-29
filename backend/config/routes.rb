Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :math_topics, only: [:index, :show]

      resources :questions, only: [:index, :show] do
        collection do
          post :generate
        end
        member do
          post :check_answer
        end
      end

      resources :users, only: [:index, :show] do
        collection do
          get :me
          get :stats
        end
      end

      post '/login', to: 'auth#create'
      post '/register', to: 'auth#register'
    end
  end
end
