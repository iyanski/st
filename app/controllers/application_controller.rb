class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Apartment::TenantNotFound, with: :tenant_not_found

  def current_company
    Company.find_by_domain(request.host_with_port)
  end

  def tenant_not_found
      raise ActionController::RoutingError.new('Not Found')
    end
end
