require "rubygems"
require "bundler/setup"
require "minitest/test_task"

require "pg"
require "active_record"
require "yaml"
require "erb"

namespace :db do
  desc "Prepare the database"
  task :prepare do
    connection_details = db_config[bot_env]
    ActiveRecord::Base.establish_connection(connection_details)

    unless ActiveRecord::Base.connection.schema_migration.table_exists?
      Rake::Task["db:create"].invoke
    end
    Rake::Task["db:migrate"].invoke
  end

  desc "Migrate the database"
  task :migrate do
    connection_details = db_config[bot_env]
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Base.connection.migration_context.migrate
  end

  desc "Create the database"
  task :create do
    connection_details = db_config[bot_env]
    admin_connection = connection_details.merge(
      "database" => "postgres",
      "schema_search_path" => "public",
    )
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch("database"))
  end

  desc "Seed the database"
  task :seed do
    connection_details = db_config[bot_env]
    ActiveRecord::Base.establish_connection(connection_details)
    Loader.load_seed
  end

  desc "Drop the database"
  task :drop do
    connection_details = db_config[bot_env]
    admin_connection = connection_details.merge(
      "database" => "postgres",
      "schema_search_path" => "public",
    )
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch("database"))
  end

  def bot_env
    ENV.fetch("BOT_ENV") { "development" }
  end

  def db_config
    template = ERB.new File.read "config/database.yml"
    YAML.safe_load template.result, aliases: true
  end
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["tests/**/*_test.rb"]
end

task :default => :test
