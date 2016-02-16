def install_and_configure_monitoring_tools
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
end
