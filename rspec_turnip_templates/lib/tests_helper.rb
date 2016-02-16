def install_rspec
  generate "rspec:install"
end

def config_rspec
  remove_file ".rspec"
  file '.rspec', <<-EOF
--color
--require spec_helper
-r turnip/rspec
--order rand
EOF
end

def factory_girl_setup
  run "mkdir 'spec/factories'"
  create_file "spec/factories/.keep"
end

def turnip_setup

  create_file 'spec/turnip_helper.rb' do <<-RUBY
Dir.glob("spec/acceptance/steps/*_steps.rb") { |f| load f, true }
  RUBY
  end

  run "mkdir 'spec/acceptance'"
  create_file "spec/acceptance/.keep"

  run "mkdir 'spec/acceptance/steps'"
  create_file "spec/acceptance/steps/.keep"
end

def config_testing_framework
  install_rspec
  config_rspec
  factory_girl_setup
  turnip_setup
  run "guard init"
end

def run_tests
  after_bundle do
    run "bundle exec rspec"
  end
end

def generate_test_monitoring_scope

  create_file 'spec/controllers/monitoring_controller_spec.rb' do <<-RUBY
require 'rails_helper'

RSpec.describe MonitoringController, :type => :controller do
describe 'GET version' do
  it 'gets the version of the app' do
    xhr :get, :version
    expect(response.body).to eq APPLICATION_CURRENT_VERSION
  end
end

describe 'GET ping' do
  it 'gets a 200 status code' do
    xhr :get, :ping
    expect(response).to have_http_status(200)
  end
end 
end
  RUBY
  end

  create_file 'spec/acceptance/monitoring_path.feature' do <<-RUBY
Feature: Visiting monitoring page
  Scenario: I visit the monitoring version page
    Given I am on the version page
    Then I should read the number of the app

  Scenario: I visit the monitoring  ping page
    Given I am on the ping page
    Then I should get a 200 status code
  RUBY
  end

  create_file 'spec/acceptance/steps/monitoring_path_steps.rb' do <<-RUBY
require 'rails_helper'

module MonitoringPathSteps
  step "I am on the version page" do
    visit monitoring_version_path
  end

  step "I am on the ping page" do
    visit monitoring_ping_path
  end

  step "I should read the number of the app" do
    expect(page).to have_content APPLICATION_CURRENT_VERSION
  end

  step "I should get a 200 status code" do
    expect(page).to have_http_status(200)
  end
end

RSpec.configure { |c| c.include MonitoringPathSteps }
  RUBY
  end
end
