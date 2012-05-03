# Add RVM's lib directory to the load path.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# Load RVM's capistrano plugin.
require "rvm/capistrano"
# Set it to the ruby + gemset of your app, e.g:
set :rvm_ruby_string, '1.9.3'
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_type, :system

set :application, "TweetGo"
set :repository, "git@bitbucket.org:rorra/borwin.git"

role :web, "199.168.97.138"
role :app, "199.168.97.138"
role :db, "199.168.97.138", :primary => true

set :user, "deploy"
set :scm, :git
set :sudo, 'rvmsudo'
set :use_sudo, false

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/borwin"
set :branch, "master"

set :asset_env, "RAILS_GROUPS=assets"

namespace :setup do
  desc "Copy config files"
  task :copy_files, :roles => :app do
    run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/.rvmrc #{release_path}/.rvmrc"
  end

  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end

  desc 'Bundle gems'
  task :bundle_gems do
    run "cd #{current_release} && #{try_sudo} bundle install --gemfile #{current_release}/Gemfile --path /var/www/borwin/shared/bundle --without development test cucumber"
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
after "deploy:update_code", "setup:trust_rvmrc"
after "deploy:update_code", "setup:bundle_gems"
after "deploy:update_code", "setup:precompile_assets"
