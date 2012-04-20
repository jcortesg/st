Borwin::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" } do
    get '/users/new_influencer', :to => 'registrations#new_influencer', :as => :influencer_devise_registration
    get '/users/new_affiliate', :to => 'registrations#new_affiliate', :as => :affiliate_devise_registration
    get '/users/new_advertiser', :to => 'registrations#new', :as => :advertiser_devise_registration
  end

  # Admin routes
  match '/admin' => 'admin/dashboard#index', :as => :admin_dashboard
  namespace :admin do
    resources :users do
      member do
        put :approve
        put :disapprove
      end
    end
  end

  # Affiliate routes
  match '/affiliate' => 'affiliate/dashboard#index', :as => :affiliate_dashboard
  namespace :affiliate do

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
      get :step_2
      put :process_step_2
      get :step_3
      put :process_step_3
      get :step_4
      put :process_step_4
    end
  end

  # Home pages
  match "advertisers-general-vision" => "home#advertisers_about", :as => :home_advertisers_about
  match "advertisers-contact" => "home#advertisers_contact", :as => :home_advertisers_contact
  match "influencers-about" => "home#influencers_about", :as => :home_influencers_about
  match "influencers-contact" => "home#influencers_contact", :as => :home_influencers_contact
  match "tweet-go" => "home#tweet_go", :as => :about_tweet_go
  match "about-us" => "home#about_us", :as => :about_us
  match "press" => "home#press", :as => :press
  match "work-with-us" => "home#work_with_us", :as => :work_with_us
  match "contact" => "home#contact", :as => :contact
  match "proces-contact" => "home#process_contact", :as => :process_contact

  match "terms" => "home#terms", :as => :terms

  match "home" => "home#index", :as => 'home'
  root :to => 'home#index'


  ##########################################
  # Review all the routes under this comment
  ##########################################

  resources :audiences_locations

  resources :transactions do
    collection do
      get ":influencer_id/:action"
    end
  end

  resources :tweets do
    collection do
      get ":id/:action"
      #get ":action/:id"
      post ":action"
    end
  end

  resources :twitter_credentials, only: [:index] do
    collection do
      get "login"
      get "finalize"
      get "publish"
      get "finalize_tweet"
    end
  end

  resources :tweet_details
  resources :currencies
  resources :payment_methods
  resources :payment_types
  resources :campaigns
  resources :locations
  resources :top_followers

  resources :audiences #do
#    collection do
#      get ":action/:influencer_id"
#    end
#  end

  resources :profiles
  resources :competitors
  resources :messages

  resources :referrals do
    collection do
      get "all"
    end
  end

  resources :influencers do
    collection do
      get "list"
      get "filter"
      post "list"
      get "fees"
      post ":influencer_id/:action"
    end
  end

  resources :advertisers
  resources :affiliates
end