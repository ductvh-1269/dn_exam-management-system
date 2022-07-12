require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DnExamManagementSystem
  class Application < Rails::Application
    Bundler.require(*Rails.groups)
    Config::Integrations::Rails::Railtie.preload
    config.time_zone = Settings.time_zone
    config.load_defaults 6.1
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.factory_bot.definition_file_paths = ["spec/factories"]
  end
end
