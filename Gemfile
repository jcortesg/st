source 'https://rubygems.org'

gem 'rails', '3.2.11'

gem 'jquery-rails'                     # JQuery
gem 'capistrano'                       # Deploy
gem 'rvm-capistrano'                   # Deploy
gem 'haml'                             # Vies
gem 'mysql2'                           # Database
gem 'devise', '2.2.2'                  # Authentication
gem 'omniauth-twitter'                 # Authentication with twitter
gem 'cancan'                           # Permissions
gem 'simple_form'                      # Rails form builder
gem 'paperclip'                        # Image Processing
gem 'kaminari'                         # Pagination
gem 'meta_search'                      # For column sort and search of tables
gem 'twitter', '2.5.0'                          # Twitter
gem 'nested_form', :git => 'https://github.com/ryanb/nested_form.git' # Nested forms
gem 'country_select'                   # For country select on user registration
gem 'active_attr'                      # Tableless models
gem 'state_machine'                    # State machine, used mainly for tweet states
gem 'mechanize'                        # Robot to brose twitter users
gem 'klout'                            # Klout index
gem 'wicked_pdf'                       # PDF Generation
gem 'gibbon'                           # Mailchimp integration
gem 'rmagick'                          # Image treatment
gem 'carrierwave'                      # Image treatment
gem 'json'                             # JSON
gem 'geocoder'                         # Gets Location from IP
gem 'capistrano-multiconfig'           # Multideployments with Capistrano

group :assets do
  gem 'sass-rails',   '~> 3.2.4'       # SASS Support
  gem 'coffee-rails', '~> 3.2.2'       # Cofeescript compilation
  gem 'uglifier', '>= 1.0.3'           # JS Minimizer

  gem 'compass-rails'                  # General mixins for css
  gem 'bootstrap-sass'                 # Kickstart styles for the app

  gem 'execjs'                         # For compiling assets
  #gem 'therubyracer'                   # For compiling assets
end

group :test do
  gem 'turn', :require => false                  # Test output
  gem 'simplecov'                                # Code coverage
  gem 'database_cleaner'                         # Clean database strategy
  gem 'factory_girl_rails'                       # Fixtures
  gem 'ffaker'                                   # Generate test data
  gem 'launchy'                                  # To open pages when developing capybara tests
  #gem 'linecache19', '0.5.13'
  #gem 'ruby-debug-base19', '0.11.25'
  gem 'ruby-debug19', :require => 'ruby-debug'   # Debug on testing
end

group :development, :test do
  gem 'capybara'                       # Browser engine
  gem 'rspec-rails'                    # RSpec testing and rspec generator
  gem 'haml-rails'                     # Haml generator
end