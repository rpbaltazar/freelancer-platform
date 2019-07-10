require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'ros/core'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectStore
  class Application < Rails::Application
    require 'rails-html-sanitizer'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    if Rails.env.development?
      initializer :console_methods do |_app|
        # TODO: Test that this works for factories
        Ros.config.factory_paths += Dir[Pathname.new(__FILE__).join('../spec/factories')]
        Ros.config.model_paths += config.paths['app/models'].expanded
      end
    end

    initializer :service_values do |_app|
      name = self.class.name.split('::').first
      Settings.service['name'] = name.downcase
      Settings.service['policy_name'] = name
    end

    # config.hosts << "project_store"
  end
end
