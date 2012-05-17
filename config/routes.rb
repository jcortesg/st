Borwin::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get '/users/new_influencer', :to => 'registrations#new_influencer', :as => :influencer_devise_registration
    get '/users/new_affiliate', :to => 'registrations#new_affiliate', :as => :affiliate_devise_registration
    get '/users/new_advertiser', :to => 'registrations#new', :as => :advertiser_devise_registration
  end

  # Admin routes
  match '/admin' => 'admin/dashboard#index', :as => :admin_dashboard
  namespace :admin do
    resources :advertisers
    resources :affiliates
    resources :influencers do
      resource :audience, only: [:show, :edit, :update]
    end

    resources :users do
      member do
        put :approve
        put :disapprove
      end
    end

    resources :referrers
  end

  # Affiliate routes
  match '/affiliate' => 'affiliate/dashboard#index', :as => :affiliate_dashboard
  namespace :affiliate do
    match '/profile' => 'profiles#show', as: :profile
    namespace :profiles do
      get :contact_data
      get :edit_contact_data
      put :process_contact_data
      get :payment_data
      get :edit_payment_data
      put :process_payment_data
    end
    resources :referrals, only: [:index, :show] do
      get :list, on: :collection
      put :update_options, on: :collection
    end
    resources :transactions, only: [:index, :show]
  end

  # Advertiser routes
  match '/advertiser' => 'advertiser/dashboard#index', :as => :advertiser_dashboard
  namespace :advertiser do
  end

  # Influencer routes
  match '/influencer' => 'influencer/dashboard#index', :as => :influencer_dashboard
  namespace :influencer do
    # Registration
    resource :registration, controller: 'registration' do
      get :link_twitter
      get :step_2
      put :process_step_2
      get :step_3
      put :process_step_3
    end
    match '/profile' => 'profiles#show', as: :profile
    namespace :profiles do
      get :edit
      put :update
      get :contact_data
      get :edit_contact_data
      put :process_contact_data
      get :payment_data
      get :edit_payment_data
      put :process_payment_data
      put :update_photo
    end
    resources :campaigns, only: [:index, :show]
    resources :referrals, only: [:index, :show] do
      get :list, on: :collection
      put :update_options, on: :collection
    end
    resources :transactions, only: [:index, :show]
  end

  # Twitter credentials
  resources :twitter_credentials, only: [:index] do
    collection do
      get "login"
      get "finalize"
      get "publish"
      get "finalize_tweet"
    end
  end

  # Home pages
  match "advertisers-general-vision" => "home#advertisers_about", :as => :home_advertisers_about
  match "advertisers-contact" => "home#advertisers_contact", :as => :home_advertisers_contact
  match "advertisers-presentation" => "home#advertisers_presentation", :as => :home_advertisers_presentation
  match "influencers-about" => "home#influencers_about", :as => :home_influencers_about
  match "influencers-contact" => "home#influencers_contact", :as => :home_influencers_contact
  match "influencers-presentation" => "home#influencers_presentation", :as => :home_influencers_presentation
  match "tweet-go" => "home#tweet_go", :as => :about_tweet_go
  match "about-us" => "home#about_us", :as => :about_us
  match "press" => "home#press", :as => :press
  match "work-with-us" => "home#work_with_us", :as => :work_with_us
  match "contact" => "home#contact", :as => :contact
  match "proces-contact" => "home#process_contact", :as => :process_contact

  match "terms" => "home#terms", :as => :terms
  match "privacy" => "home#privacy", :as => :privacy

  # Invitation route
  match "/I:invitation_code", to: "home#invitation", contrainsts: {invitation_code: /[A-Z0-9]{6}/}

  root :to => 'home#index'
end