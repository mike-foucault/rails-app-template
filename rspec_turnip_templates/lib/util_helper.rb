def clean_bundle
  after_bundle do
    remove_dir "app/mailers"
    remove_dir "app/helpers"
    remove_dir "test"
    load_gitignore
    git :init
    git add: "."
    git commit: %Q{ -m 'Initial commit' }
  end
end

def generate_monitoring_controller
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
end

def generate_monitoring_route
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
end

def generate_app_version_initializers
  inside 'config/initializers' do
    create_file 'version.rb' do <<-RUBY
APPLICATION_CURRENT_VERSION = "0.0.0"
    RUBY
    end
  end
end

def generate_monitoring_scope
  generate_monitoring_controller
  generate_app_version_initializers
  generate_monitoring_route
end

def config_editor
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
end

def config_dot_env
  file '.env.development', <<-EOF
# DEVELOPMENT Environment Variables
  EOF

  file '.env.test', <<-EOF
# TEST Environment Variables
  EOF
end

def load_ruby_version
  file '.ruby-version', <<-EOF
2.3.0
  EOF
end

def load_gitignore
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
end

def load_read_me
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
end

