class TenantMiddleware < Apartment::Elevators::Subdomain
  def call(*args)
    begin
      super
    rescue Apartment::TenantNotFound
      # Rails.logger.error "ERROR: Apartment Tenant not found: #{Apartment::Tenant.current.inspect}"
      # return [404, {"Content-Type" => "application/json"}, ["Error" => "Tenant not found"]]
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def parse_tenant_name(request)
    request.env['HTTP_X_TENANT']
  end
end