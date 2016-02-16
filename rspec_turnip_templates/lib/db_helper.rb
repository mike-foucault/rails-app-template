def config_db
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
end

def create_dbs
  rake "db:create:all"
end
