lock '3.4.0'
set :application, ENV["APP_NAME"]
set :repo_url, ENV['GIT_REPO']
set :project_root_path, File.dirname(File.expand_path('./../',__FILE__))
set :format, :pretty
set :keep_releases, 2
set :deploy_to, ENV["PROJECT_PATH"]
set :branch, ENV["BRANCH"] || `git rev-parse --abbrev-ref HEAD`.chop
set :user, 'poc'
set :use_sudo, false
# rbenv 的設定
set :rbenv_type, :user 

set :rbenv_ruby, "2.2.2"
set :rbenv_path, "/home/poc/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all 
# set:rails_env, :production
# set :using_rvm, false   # using rbenv
set :rbenv_type, :user
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/bin:$HOME/local/bin:$PATH"
}
set :bundle_binstubs, nil 
set :log_level, :debug
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
set :file_permissions_roles, :all
set :file_permissions_paths, [
  "tmp",
  "log",
]
set :file_permissions_chmod_mode, "0777"

# load 'config/deploy/recipes/nginx.rb'
# load 'config/deploy/recipes/foreman.rb'
# load 'config/deploy/recipes/deploy.rb'
