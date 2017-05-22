module ApplicationHelper
  def current_company
    Company.find_by_domain(request.host_with_port)
  end

  def current_store
    Store.first
  end
end
