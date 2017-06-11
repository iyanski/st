class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Apartment::TenantNotFound, with: :tenant_not_found
  before_action :switch_tenant

  def current_company
    Company.find_by_domain(request.host_with_port)
  end

  def tenant_not_found
    begin 
      switch_tenant
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def switch_tenant
    if request.host_with_port == ENV["app_url"]
      Apartment::Tenant.switch!("public")
    end
  end
end
