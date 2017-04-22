require_relative 'boot'

require 'rails/all'
require 'apartment/elevators/subdomain'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Smalltasker
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.middleware.use 'Apartment::Elevators::Subdomain'
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << File.join(Rails.root, "/vendor/pages")
    config.assets.paths << File.join(Rails.root, "/vendor/plugins")
    config.generators.javascripts = false
    config.generators.stylesheets = false
    config.angular_templates.module_name    = 'templates'
    config.angular_templates.ignore_prefix  = %w(user/templates/ customer/templates/ expert/templates/)
    config.angular_templates.markups        = %w(haml)
    config.angular_templates.htmlcompressor = false

  end
end
