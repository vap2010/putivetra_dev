require "bundler/capistrano"
load 'deploy/assets'

set :application, "Putivetra"
# set :repository,  "git@github.com:oruen/putivetra.git"
set :repository,  "git@github.com:vap2010/putivetra_dev.git"
set :user, "application"
set :deploy_to, "/application/rails/putivetra"
set :use_sudo, false
set :rake, "bundle exec rake"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server = "94.127.69.158"

role :web, server                          # Your HTTP server, Apache/etc
role :app, server                          # This may be the same as your `Web` server
role :db,  server, :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
after "deploy:update_code", "deploy:migrate"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

