Rails.application.routes.draw do
  devise_for :users
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

  resources :companies do
    collection do
      post :check
      get :continue
    end
  end
end
