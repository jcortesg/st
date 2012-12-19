# Add RVM's lib directory to the load path.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# Load RVM's capistrano plugin.
require "rvm/capistrano"
# Set it to the ruby + gemset of your app, e.g:
set :rvm_ruby_string, '1.9.3'
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_type, :system

set :application, "TweetGo Mexico"
set :repository, "git@bitbucket.org:redmint/borwin.git"

#role :web, "199.168.97.138"
#role :app, "199.168.97.138"
#role :db, "199.168.97.138", :primary => true
role :web, "142.54.169.210"
role :app, "142.54.169.210"
role :db, "142.54.169.210", :primary => true

set :user, "deploy"
set :scm, :git
set :sudo, 'rvmsudo'
set :use_sudo, false

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/borwin-mexico"
set :branch, "master"

set :asset_env, "RAILS_GROUPS=assets"

namespace :setup do
  desc "Copy config files"
  task :copy_files, :roles => :app do
    run "cp #{release_path}/config/i18n-database/database-MX.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/.rvmrc #{release_path}/.rvmrc"
  end

  desc "Copy config files for colombia"
  task :copy_config_files, :roles => :app do
    run "cp -r #{release_path}/config/i18n-env-production/production-MX.rb #{release_path}/config/environments/production.rb"
    run "cp -r #{release_path}/config/i18n-config/config-MX.yml #{release_path}/config/config.yml"
    run "cp -r #{release_path}/config/i18n-files/application-MX.rb #{release_path}/config/application.rb"
  end

  desc "Copy pictures files"
  task :copy_pictures, :roles => :app do
    #run "cp -r #{previous_release}/public/bwn-image #{release_path}/public/"
  end

  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end

  desc 'Bundle gems'
  task :bundle_gems do
    run "cd #{current_release} && #{try_sudo} bundle install --gemfile #{current_release}/Gemfile --path /var/www/borwin-mexico/shared/bundle --without development test cucumber"
  end

  desc 'Precompile assets'
  task :precompile_assets, :roles => :app do
    run "cd #{release_path} && bundle exec #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

after "deploy:update_code", "setup:copy_files"
after "deploy:update_code", "setup:copy_config_files"
after "deploy:update_code", "setup:trust_rvmrc"
after "deploy:update_code", "setup:copy_pictures"
after "deploy:update_code", "setup:bundle_gems"
after "deploy:update_code", "setup:precompile_assets"