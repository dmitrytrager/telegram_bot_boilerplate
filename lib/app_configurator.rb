require "logger"
require "erb"
require "dotenv"

require "./lib/database_connector"

class AppConfigurator
  def configure
    Dotenv.load

    setup_i18n
    setup_database
  end

  def token
    template = ERB.new File.read "config/secrets.yml"
    YAML.safe_load(template.result, aliases: true).dig(bot_env, "telegram_bot_token")
  end

  def logger
    Logger.new($stderr, Logger::DEBUG)
  end

  private

  def bot_env
    ENV.fetch("BOT_ENV") { "development" }
  end

  def setup_i18n
    I18n.load_path = Dir["config/locales.yml"]
    I18n.locale = :ru
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
