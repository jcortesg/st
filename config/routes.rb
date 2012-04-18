Borwin::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" } do
    get '/users/new_influencer', :to => 'registrations#new_influencer', :as => :influencer_devise_registration
    get '/users/new_affiliate', :to => 'registrations#new_affiliate', :as => :affiliate_devise_registration
    get '/users/new_advertiser', :to => 'registrations#new', :as => :advertiser_devise_registration
  end
  #do
  #	get "users/password" => "users#edit"
  #	get "users/all" => "users#all", :as => 'all_users'
  #	post "users/:id/approve" => "users#approve"
  #	post "users/:id/disapprove" => "users#approve"
  #end

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
    end
  end

  # Home pages
  match "borwin-for-advertisers" => "welcome#advertisers", :as => :welcome_advertisers
  match "borwin-for-influencers" => "welcome#influencers", :as => :welcome_influencers
  match "analytics" => "welcome#analytics", :as => :welcome_analytics
  match "about" => "welcome#about", :as => :about
  match "contact" => "welcome#contact", :as => :contact
  match "process_contact" => "welcome#process_contact", :as => :process_contact
  match "terms" => "welcome#terms", :as => :terms





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

  resources :twitter_credentials do
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

  #resources :influencers do
  #  collection do
  #    get "list"
  #    get "filter"
  #    post "list"
  #    get "fees"
  #    post ":influencer_id/:action"
  #  end
  #end

  resources :advertisers
  resources :affiliates

  match "home" => "home#index", :as => 'home'
  root :to => 'welcome#index'
end