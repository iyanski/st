# You can have Apartment route to the appropriate Tenant by adding some Rack middleware.
# Apartment can support many different "Elevators" that can take care of this routing to your data.
# Require whichever Elevator you're using below or none if you have a custom one.
#
require 'apartment/elevators/generic'
# require 'apartment/elevators/domain'
# require 'apartment/elevators/subdomain'
# require 'apartment/elevators/first_subdomain'

#
# Apartment Configuration
#
Apartment.configure do |config|
  config.excluded_models = %w{ User Company }
  config.tenant_names = lambda { Company.pluck :subdomain }
  # config.default_schema = "smalltaskers"
end


# Rails.application.config.middleware.use 'Apartment::Elevators::Domain'

# Apartment::Elevators::FirstSubdomain.excluded_subdomains = ['www']
# Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.use 'Apartment::Elevators::FirstSubdomain'
# Rails.application.config.middleware.insert_before 'Warden::Manager', 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.use(TenantMiddleware)
# Rails.application.config.middleware.insert_before 'Warden::Manager', 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.insert_before 'Warden::Manager', 'Apartment::Elevators::Domain'
# Apartment::Elevators::Subdomain.excluded_subdomains = ['www', 'blog', 'developers', 'pay', 'press', 'api', 'store', 'shop', 'smalltaskers']
# Rails.application.config.middleware.use 'Apartment::Elevators::Domain'
Rails.application.config.middleware.use Apartment::Elevators::Generic, Proc.new { |request| 
  if request.host_with_port == ENV["app_url"]
    "public"
  else
    company = Company.where(domain: request.host_with_port).first
    "#{company.subdomain}.#{ENV['app_url']}"
  end
}
# Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'