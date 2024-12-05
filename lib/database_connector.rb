require "active_record"
require "logger"

class DatabaseConnector
  class << self
    def establish_connection
      ActiveRecord::Base.logger = Logger.new(active_record_logger_path)

      template = ERB.new File.read database_config_path
      configuration = YAML.load(template.result, aliases: true)

      ActiveRecord::Base.establish_connection(configuration[bot_env])
    end

    private

    def active_record_logger_path
      "debug.log"
    end

    def database_config_path
      "config/database.yml"
    end

    def bot_env
      ENV.fetch("BOT_ENV") { "development" }
    end
  end
end
