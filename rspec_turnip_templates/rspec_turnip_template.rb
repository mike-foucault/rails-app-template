# Basic Rails app template
# Testing Framework: 
  # - Rspec
  # - Turnip
# Server:
  # Puma
# Monitoring: RollBar & NewRelic


####################################################
# GemFile ##########################################
require_relative 'lib/db_helper'
require_relative 'lib/gem_helper'
require_relative 'lib/monitoring_helper'
require_relative 'lib/tests_helper'
require_relative 'lib/util_helper'

install_gems(bundle: true)
config_testing_framework
config_db
config_dot_env
config_editor
load_ruby_version
load_read_me
install_and_configure_monitoring_tools
generate_monitoring_scope
generate_test_monitoring_scope
create_dbs
clean_bundle
run_tests
