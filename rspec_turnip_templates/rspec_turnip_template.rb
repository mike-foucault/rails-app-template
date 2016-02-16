# Basic Rails app template
# Testing Framework: 
  # - Rspec
  # - Turnip
# Server:
  # Puma
# Monitoring: RollBar & NewRelic


####################################################
# GemFile ##########################################
remove_file "Gemfile"
file 'Gemfile', <<-EOF
ruby "2.3.0"
EOF
add_source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4', group: :doc
# Decorator
gem 'draper', '~> 2'
# Form Object
gem 'reform', '~> 2'
# Server: Production
gem 'puma', '~> 2'

gem_group :development do
  gem 'guard', '~> 2'
  gem 'guard-rspec', '~> 4', require: false
  gem 'terminal-notifier-guard', '~> 1'
end

gem_group :test do
  gem 'rspec-mocks', '~> 3'
  gem 'capybara', '~> 2'
  gem 'factory_girl_rails', '~> 4'
  gem 'faker', '~> 1'
  gem 'shoulda-matchers', '~> 3'
  gem 'turnip', '~> 2'
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3'
  gem 'dotenv-rails', '~> 2'
  gem 'byebug', '~> 8'
  gem 'web-console', '~> 2'
  gem 'pry', '~> 0.10'
  gem 'spring', '~> 1'
end

gem_group :production do
  gem 'rollbar', '~> 2.7'
  gem 'newrelic_rpm', '~> 3.14'
end

run 'bundle install'

# RSPEC Setup
generate "rspec:install"
run "guard init"

run "mkdir 'spec/factories'"
create_file "spec/factories/.keep"

run "mkdir 'spec/acceptance'"
create_file "spec/acceptance/.keep"

run "mkdir 'spec/acceptance/steps'"
create_file "spec/acceptance/steps/.keep"

file '.env.development', <<-EOF
  # DEVELOPMENT Environment Variables
EOF

file '.env.test', <<-EOF
  # TEST Environment Variables
EOF

file '.editorconfig', <<-EOF
root = true
[*]
# Change these settings to your own preference
indent_style = space
indent_size = 2
# We recommend you to keep these unchanged
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
[*.md]
trim_trailing_whitespace = false
EOF

remove_file ".gitignore"
file '.gitignore', <<-EOF
/.bundle
/log/*
!/log/.keep
/tmp
.DS_Store
.env.development
.env.test
EOF

file '.ruby-version', <<-EOF
  2.3.0
EOF

remove_file ".rspec"
file '.rspec', <<-EOF
--color
--require spec_helper
-r turnip/rspec
--order rand
EOF

inside 'config' do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF

default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: #{app_name}_development

test:
  <<: *default
  database: #{app_name}_test

production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>

EOF
  end
end

run "newrelic install --license_key='<%= ENV[\"NEW_RELIC_LICENSE_KEY\"] %>' '#{app_name}'"

inside 'config/initializers' do
  create_file 'rollbar.rb' do <<-RUBY
require 'rollbar'

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  if Rails.env.test?
    config.enabled = false
  end

  config.environment = ENV['ROLLBAR_ENV'] || Rails.env
end

  RUBY
  end
end

remove_file "README.rdoc"
file 'README.rdoc', <<-EOF
== README
* Ruby version
2.3.0.
* How to run the test suite
bundle exec guard
* Production instructions
Don't forget to set: 
  SECRET_KEY_BASE
  DATABASE_URL
  ROLLBAR_ACCESS_TOKEN
EOF

inside 'config/initializers' do
  create_file 'version.rb' do <<-RUBY
APPLICATION_CURRENT_VERSION = "0.0.0"
  RUBY
  end
end

create_file 'app/controllers/monitoring_controller.rb' do <<-RUBY
class MonitoringController < ApplicationController
  def version
    version = APPLICATION_CURRENT_VERSION
    render json: version
  end

  def ping
    render nothing: true, status: 200
  end
end
RUBY
end

remove_file "config/routes.rb"
create_file 'config/routes.rb' do <<-RUBY
Rails.application.routes.draw do
  root 'monitoring#version'
  scope :monitoring, as: :monitoring do
    get 'version' => 'monitoring#version'
    get 'ping'    => 'monitoring#ping'
  end
end
RUBY
end

rake "db:create"
rake "db:migrate"

after_bundle do
  remove_dir "app/mailers"
  remove_dir "app/helpers"
  remove_dir "test"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

