source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem "bootstrap-sass"

# Banco de Dados Mongo
gem 'mongoid', github: 'mongoid/mongoid'
gem 'bson_ext'
# Autorização e Permissionamento
gem 'devise'
gem 'cancancan'
gem 'jquery-inputmask-rails'

## Interface de Admin
gem "wysiwyg-rails"
gem 'icheck-rails'
gem 'rails_admin_change_password', git: 'https://github.com/cec/rails_admin_change_password.git'
gem 'rails_admin_rollincode', :git => 'https://github.com/rmhulle/rails_admin_theme.git'
gem 'rails_admin'
gem "rails_admin_import", "~> 1.4"
gem 'rails_admin_toggleable'
gem 'mongoid-audit'
gem "mask_validator"
gem 'money-rails', :git =>'https://github.com/rmhulle/money-rails.git'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
#gem 'roadie-rails'
gem "chartkick"
gem 'premailer-rails'

gem 'mina'
gem 'unicorn'
gem 'mina-unicorn', require: false

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# group :production do
# gem 'rails_admin_report', :git => 'https://github.com/rmhulle/rails_admin_report.git'
# end
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'awesome_print'
  gem 'rails_admin_report', :path => '/Users/rmhulle/Documents/Projetos/Rails/rails_admin_report'
  gem 'rack-mini-profiler', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
