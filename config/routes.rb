Rails.application.routes.draw do
  mount ActionCable.server => '/suck8ts'
  
  devise_for :customers
  devise_for :experts
  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }
  root to: "home#index"
  match "/contact" => "home#contact", via: [:get], as: :contact
  match "/pricing" => "home#pricing", via: [:get], as: :pricing
  match "/howitworks" => "home#howitworks", via: [:get], as: :howitworks
  match "/guidelines" => "home#guidelines", via: [:get], as: :guidelines
  match "/terms" => "home#terms", via: [:get], as: :terms
  match "/about" => "home#about", via: [:get], as: :about
  match "/privacy" => "home#privacy", via: [:get], as: :privacy
  match "/features" => "home#features", via: [:get], as: :features
  match "/login" => "home#login", via: [:get], as: :login
  match "/redirector" => "home#redirector", via: [:post, :get], as: :redirector
  match "/app" => "home#app", via: [:get], as: :app                      # customers
  match "/dashboard" => "home#dashboard", via: [:get], as: :dashboard    # experts
  match "/admin" => "home#admin", via: [:get], as: :admin                # administrator
  match "/notify" => "orders#notify", via: [:post, :get], as: :notify

  resources :companies do
    collection do
      post :check
      get :continue
    end
  end

  resources :conversations, params: :slug
  resources :messages

  namespace :api do
    namespace :users do
      resources :jobs
      resources :experts
      resources :customers
      resources :services do
        resources :benefits
        resources :requirements
        resources :faqs
        member do
          put :upload
        end
      end
      resources :companies do
        collection do
          post :domain
        end
      end
    end


    namespace :experts do
      resource :account do
        member do
          post :upload
        end
      end
      resource :settings
      resources :jobs do
        member do
          put :claim
          put :unclaim
          put :estimate
          put :cancel
          put :submit
          put :upload
          post :chat
          post :upload
        end
      end
    end


    namespace :customers do
      resource :account do
        member do
          post :upload
        end
      end
      resource :settings
      resource :orders do
        collection do
          get 'express/:job_id' => "orders#express", via: [:post], as: :express
        end
      end
      resources :jobs do
        member do
          put :publish
          put :unpublish
          put :decline
          put :cancel
          put :complete
          post :chat
          post :pay
          post :upload
        end
      end
    end
  end
  resources :job
  resources :orders do
    collection do
      get :return
      get :cancel
    end
  end
end
