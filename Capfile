$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require 'capistrano-deploy'

use_recipes :git, :rails, :bundle, :unicorn, :whenever, :multistage, :rails_assets

server '50.17.233.46', :web, :app, :db, :primary => true

stage :axeda, :default => true do
  set :rvm_ruby_string, 'ruby-1.9.3-p125@calamp'
  set :user, 'fleet'
  set :deploy_to, '/home/fleet/web-app'
  set :repository, 'git@github.com:JJCOINCWEBDEV/calamp.git'

  #find the path by using 'which rvm' in server.
  # If rvm is installed for fleet user remove the following line
  #set :rvm_bin_path, "/usr/local/rvm/bin"
end

set :whenever_cmd, 'bundle exec whenever'

after 'deploy:update',  'bundle:install'
after 'deploy:update', 'deploy:assets:precompile'
after 'deploy:restart', 'whenever:update_crontab'
after 'deploy:restart', 'unicorn:reload'

