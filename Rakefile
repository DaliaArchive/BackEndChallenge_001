require 'sinatra'
require 'active_record'

task :environment do      
  Sinatra::Application.environment = ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection YAML.load_file("db/database.yml")[ENV['RACK_ENV']]
end

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end