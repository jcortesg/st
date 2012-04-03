Borwin::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users" } do

  #devise_scope :users do  	
  	get "users/password" => "users#edit"
  	get "users/all" => "users#all"
  	post "users/:id/approve" => "users#approve"
  	post "users/:id/disapprove" => "users#approve"
  end

  root :to => 'welcome#index'
  
  match "alta" => redirect('/users/sign_up')

  match "home" => "home#index"
  
  match "borwin-for-advertisers" => "welcome#advertisers"
  match "borwin-for-influencers" => "welcome#influencers"
  match "analytics" => "welcome#analytics"  
  match "about" => "welcome#about"
  match "contact" => "welcome#contact"
  match "contact_post" => "welcome#contact_post"
  match "terms" => "welcome#terms"  
    
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