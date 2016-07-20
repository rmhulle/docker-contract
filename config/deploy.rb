require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/unicorn'


# IP do seu servidor
set :domain, '192.241.136.70'

# Caminho da pasta de deploy
set :deploy_to, '/home/deployer/contracts'

# Repositorio do seu github/gitlab/bitbucket
set :repository, 'git@github.com:rmhulle/contracts.git'
# Branch do projeto
set :branch, 'master'
set :user, 'deployer'
# Porta do seu servidor ssh
set :port, '22'
# PID do unicorn
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
# Permitir por senha o deploy
set :term_mode, nil
set :stage, 'production'
set :rails_env, "production"

# Caminho do RVM instalado. Ele ja assume que estara no caminho padrao. Caso nao, modifique aqui:
#rvm gemdir
#set :rvm_path, '/usr/local/rvm/bin/rvm'

# Arquivos compartilhados
set :shared_paths, ['config/mongoid.yml', 'config/secrets.yml', 'log']
set :app_path, "#{deploy_to}/#{current_path}"
# Quantidade de releases para manter em producao
set :keep_releases, 4

  task :environment do
    queue %{
  echo "-----> Loading environment"
  #{echo_cmd %[source ~/.bashrc]}
  }
    invoke :'rbenv:load'
    # If you're using rbenv, use this to load the rbenv environment.
    # Be sure to commit your .rbenv-version to your repository.
  end

  task :setup => :environment do
    queue! %[mkdir -p "#{deploy_to}/shared/log"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

    queue! %[mkdir -p "#{deploy_to}/shared/config"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

    # UNICORN
    # /home/deploy/apps/<app>/shared/pids/unicorn.pid
    #
    queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

    # /home/deploy/apps/<app>/shared/sockets/unicorn.sock
    #
    queue! %[mkdir -p "#{deploy_to}/#{shared_path}/sockets"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/sockets"]


    queue! %[touch "#{deploy_to}/shared/config/mongoid.yml"]
    queue  %[echo "-----> Be sure to edit 'shared/config/mongoid.yml'."]

    queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
    queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  end

desc "Deploys the current version to the server."
  task :deploy => :environment do
    deploy do

      invoke :'git:clone'
      invoke :'deploy:link_shared_paths'
      invoke :'bundle:install'
      invoke :'rails:assets_precompile'
      invoke :'deploy:cleanup'

      to :launch do
        invoke :'unicorn:restart'
       # queue RAILS_ENV=production bundle exec rake assets:precompile && bundle exec unicorn -E RAILS_ENV=production -D
        queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
        queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      end
    end
end
