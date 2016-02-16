def install_gems(options = {})
  remove_file "Gemfile"
  file 'Gemfile', <<-EOF
ruby "2.3.0"
  EOF
  add_source 'https://rubygems.org'

  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '~> 4.2'
  # Use postgresql as the database for Active Record
  gem 'pg', '~> 0.18'
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
    gem 'web-console', '~> 2'
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
    gem 'pry', '~> 0.10'
    gem 'spring', '~> 1'
  end

  gem_group :production do
    gem 'rollbar', '~> 2.7'
    gem 'newrelic_rpm', '~> 3.14'
  end

  bundle_install if options[:bundle] == true
end

def bundle_install
  run 'bundle install'
end
