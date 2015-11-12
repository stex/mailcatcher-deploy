require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'
require 'dotenv'

Dotenv.load

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain,      ENV['DEPLOY_DOMAIN']
set :deploy_to,   ENV['DEPLOY_TO']
set :repository, 'https://github.com/stex/mailcatcher-deploy.git'
set :branch,     'master'

set :rvm_string, ENV['DEPLOY_RVM_STRING']

set :shared_paths, ['log']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # For those using RVM, use this to load an RVM version@gemset.
  invoke :"rvm:use[#{rvm_string}]"
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  # Puma needs a place to store its pid file and socket file.
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
  end
end

namespace :mailcatcher do
  set_default :bundle_prefix,         -> { 'bundle exec' }
  set_default :mailcatcher_cmd,       -> { "#{bundle_prefix} mailcatcher" }
  set_default :mailcatcher_smtp_ip,   -> { '0.0.0.0' }
  set_default :mailcatcher_smtp_port, -> { '1025' }
  set_default :mailcatcher_http_ip,   -> { '0.0.0.0' }
  set_default :mailcatcher_http_port, -> { '1388' }


  desc 'Starts a new mailcatcher on the server'
  task :start => :environment do
    queue! %[cd #{deploy_to}/#{current_path} && #{mailcatcher_cmd} --smtp-ip #{mailcatcher_smtp_ip} --smtp-port #{mailcatcher_smtp_port} --http-ip #{mailcatcher_http_ip} --http-port #{mailcatcher_http_port}]
  end
end