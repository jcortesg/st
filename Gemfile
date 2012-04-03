source 'http://rubygems.org'

gem 'rails', '3.2.3'

gem 'jquery-rails'      # JQuery
gem 'capistrano'        # Deploy
gem 'haml'              # Vies
gem 'mysql2'            # Database
gem 'devise'            # Authentication
gem 'twitter_oauth'     # Authentication with twitter
gem 'cancan'            # Permissions
gem 'formtastic'        # Quick forms
gem 'paperclip'         # Image Processing
gem 'kaminari'          # Pagination
gem 'twitter'           # Twitter

group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.0.3'

  gem 'execjs'         # For compiling assets
  gem 'therubyracer'   # For compiling assets
end

group :test do
  gem 'turn', :require => false    # Test output
  gem 'simplecov'                  # Code coverage
end

group :development, :test do
  gem 'capybara'        # Browser engine
  gem 'rspec-rails'     # RSpec testing and rspec generator
  gem 'haml-rails'      # Haml generator
end