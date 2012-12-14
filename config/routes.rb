Borwin::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get '/users/new_influencer', :to => 'registrations#new_influencer', :as => :influencer_devise_registration
    get '/users/new_affiliate', :to => 'registrations#new_affiliate', :as => :affiliate_devise_registration
    get '/users/new_advertiser', :to => 'registrations#new', :as => :advertiser_devise_registration
  end

  # Omniauth
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'

  # Admin routes
  match '/admin' => 'admin/dashboard#index', :as => :admin_dashboard
  namespace :admin do
    resources :advertisers
    resources :affiliates
    resources :influencers do
      collection do
        get :waiting_approval
      end
      member do
        get :recategorize
        put :do_recategorize
        get :set_influence
        put :do_set_influence
        put :approve
        put :reject
      end
      resource :audience, only: [:show, :edit, :update]
    end

    resources :users do
      member do
        put :approve
        put :disapprove
        get :recategorize
        put :do_recategorize
        get :set_influence
        put :do_set_influence
      end
    end

    resources :referrers

    resources :campaigns do
      collection do
        get :archived
      end
      member do
        get :audience
        get :statistics
        put :set_audience
        put :archive
        put :activate
      end
      resources :clicks, only: [:index]
      match '/influencer_profile/:influencer_id' => 'tweets#influencer_profile', :as => :influencer_profile
      resources :tweets do
        get :reject, on: :member
        post :reject_cause, on: :member
        get :edit_date, on: :member
        get :accept, on: :member
        get :forced_publication, on: :member
        resources :clicks, only: [:index]
      end
    end

    resources :keywords, except: [:new, :destroy]

    resources :transactions do
      collection do
        get :new_payment
        post :create_new_payment
      end
    end

    resources :payments

    resources :cash_outs, except: [:created, :edit, :update] do
      put :pay, on: :member
    end

    match 'change_password' => 'dashboard#change_password', as: :dashboard_change_password
    match 'update_password' => 'dashboard#update_password', as: :dashboard_update_password
  end

  # Affiliate routes
  match '/affiliate' => 'affiliate/dashboard#index', :as => :affiliate_dashboard
  namespace :affiliate do
    match '/profile' => 'profiles#show', as: :profile
    namespace :profiles do
      get :show
      get :my_data
      get :edit
      put :update
      put :update_photo
      get :payment_data
      get :edit_payment_data
      put :process_payment_data
      get :change_password
      put :update_password
    end
    resources :referrals, only: [:index, :show] do
      get :list, on: :collection
      put :update_options, on: :collection
    end
    resources :transactions, only: [:index, :show]
    resources :cash_outs, only: [:index, :show, :new, :create]
  end

  # Advertiser routes
  namespace :advertiser do
    resources :campaigns, except: [:delete] do
      collection do
        get :archived
      end
      member do
        get :audience
        put :set_audience
        put :archive
        put :activate
        get :statistics
      end
      resources :clicks, only: [:index]
      match '/influencer_profile/:influencer_id' => 'tweets#influencer_profile', :as => :influencer_profile
      resources :tweets do
        resources :clicks, only: [:index]
        put :accept, on: :member
      end
    end
    resources :pictures do
      post :create
      get :show
    end
    match '/profile' => 'profiles#show', as: :profile
    namespace :profiles do
      get :show
      get :my_data
      get :edit
      put :update
      put :update_photo
      get :change_password
      put :update_password
    end
    resources :transactions, only: [:index, :show]
    resources :payments, only: [:index, :show, :new, :create, :pay]
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
      get :edit
      put :process_contact_data
      get :payment_data
      get :edit_payment_data
      put :process_payment_data
      put :process_approval_message
      put :update_photo
      get :change_password
      put :update_password
      get :best_time
    end
    resources :tweets, except: [:new, :create, :destroy] do
      put :accept, on: :member
      get :reject, on: :member
      post :reject_cause, on: :member
    end
    resources :referrals, only: [:index, :show] do
      get :list, on: :collection
      put :update_options, on: :collection
    end
    resources :transactions, only: [:index, :show]
    resources :cash_outs, only: [:index, :show, :new, :create]
  end

  # Home pages
  match "advertisers-general-vision" => "home#advertisers_about", :as => :home_advertisers_about
  match "advertisers-contact" => "home#advertisers_contact", :as => :home_advertisers_contact
  match "process-advertiser-contact" => "home#process_advertiser_contact", :as => :process_advertiser_contact
  match "advertisers-presentation" => "home#advertisers_presentation", :as => :home_advertisers_presentation
  match "influencers-about" => "home#influencers_about", :as => :home_influencers_about
  match "influencers-contact" => "home#influencers_contact", :as => :home_influencers_contact
  match "influencers-presentation" => "home#influencers_presentation", :as => :home_influencers_presentation
  match "tweet-go" => "home#tweet_go", :as => :about_tweet_go
  match "sorte-argo" => "home#sorte_argo", :as => :about_sorte_argo
  match "stats-go" => "home#stats_go", :as => :about_stats_go
  match "about-us" => "home#about_us", :as => :about_us
  match "press" => "home#press", :as => :press
  match "work-with-us" => "home#work_with_us", :as => :work_with_us
  match "contact" => "home#contact", :as => :contact
  match "proces-contact" => "home#process_contact", :as => :process_contact
  match "presentacion" => "home#presentacion", :as => :presentacion

  match "terms" => "home#terms", :as => :terms
  match "privacy" => "home#privacy", :as => :privacy

  match "country" => "home#country_redirector", :as => :country_redirector

  match "mp-endpoint" => "home#ipn_endpoint", :as => :ipn_endpoint, :via => :post

  # Invitation route
  match "/I:invitation_code", to: "home#invitation", contrainsts: {invitation_code: /[A-Z0-9]{6}/}
  match "/L:link_code", to: "home#tweet_link_redirection", contrainsts: {invitation_code: /[A-Z0-9]{4}/}
  match "/P:picture_code", to: "home#tweet_image_redirection", contrainsts: {picture_code: /[A-Z0-9]{5}/}

  match 'pictures/:id' => 'pictures#show'

  root :to => 'home#index'
end