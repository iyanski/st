Rails.application.routes.draw do
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

  resources :companies do
    collection do
      post :check
      get :continue
    end
  end

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
          put :estimate
          put :submit
          put :upload
          post :chat
          post :upload
        end
      end
    end


    namespace :customers do
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
end
