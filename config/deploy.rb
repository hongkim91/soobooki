require "bundler/capistrano"

server "106.187.94.233", :web, :app, :db, primary: true

set :application, "soobooki"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:Hong-Kim/Soobooki.git"
set :branch, "master"
set :rails_env, :production

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy:restart", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  desc "cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
    end
  end
  before "deploy", "deploy:check_revision"
end

after "deploy:update_code", :bundle_install
desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

namespace :customs do
  task :config, :roles => :app do
    run "ln -nfs #{shared_path}/system/database.yml #{current_path}/config/database.yml"
    run "ln -nfs #{shared_path}/system/setup_mailer.rb #{current_path}/config/setup_mailer.rb"
  end
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/system/uploads #{current_path}/public/uploads"
  end
end
after "deploy:update_code", "customs:config"
after "deploy:create_symlink","customs:symlink"

desc "I don't know why but this makes rmagick work"
task :bundle_no_deploy, :roles => :app do
  run "cd #{current_path}; bundle install --no-deployment --quiet"
end
after "deploy:restart", :bundle_no_deploy
