class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_company
    Company.find_by_domain(request.host_with_port)
  end
end
