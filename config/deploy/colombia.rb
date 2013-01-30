set :application, "SocialTarget"
set :repository, "git@bitbucket.org:sjasminoy/social-target.git"

role :web, "www.social-target.net"
role :app, "www.social-target.net"
role :db, "www.social-target.net", :primary => true

set :user, "deploy"
set :scm, :git
set :sudo, 'rvmsudo'
set :use_sudo, false

set :deploy_via, :remote_cache
set :deploy_to, "/u/apps/social-target-co"
set :branch, "master"

namespace :setup do
  desc "Copy config files"
  task :copy_files, :roles => :app do
    run "cp #{release_path}/config/i18n-database/database-CO.yml #{release_path}/config/database.yml"
  end

  desc "Copy config files for colombia"
  task :copy_config_files, :roles => :app do
    run "cp -r #{release_path}/config/i18n-env-production/production-CO.rb #{release_path}/config/environments/production.rb"
    run "cp -r #{release_path}/config/i18n-config/config-CO.yml #{release_path}/config/config.yml"
    run "cp -r #{release_path}/config/i18n-files/application-CO.rb #{release_path}/config/application.rb"
  end

  desc 'Link bwn images'
  task :link_bwn_images do
    run "ln -s #{shared_path}/bwn-image #{release_path}/public/bwn-image"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

before "deploy:assets:precompile", "setup:copy_files"
before "deploy:assets:precompile", "setup:copy_config_files"
before "deploy:assets:precompile", "setup:link_bwn_images"
