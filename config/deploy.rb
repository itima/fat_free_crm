set :user, "alexey"
set :use_sudo, sudo
set :domain, 'probaz.ru'
set :application, 'itima-crm'

set :repository,  "git@github.com:itima/fat_free_crm.git" 
set :deploy_to, "/var/www/itima-crm"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

role :web, "probaz.ru"                          # Your HTTP server, Apache/etc
role :app, "probaz.ru"                          # This may be the same as your `Web` server
role :db,  "probaz.ru", :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Make symlink for database yaml" 
  task :symlink do
    db_config = "/var/www/#{application}/shared/conf/database.yml"
    run "ln -nfs #{db_config} #{current_path}/config/database.yml" 
    run "touch #{current_path}/tmp/restart.txt"    
  end
  
end

# 
# # Avoid keeping the database.yml configuration in git.
# task :copy_database_yml, :roles => :app do
#   db_config = "/var/www/#{application}/conf/database.yml"
#   run "cp #{db_config} #{current_path}/config/database.yml"
# end
