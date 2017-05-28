class ServicesController < ApplicationController
  layout 'storepage'
  helper_method :resource_name, :resource, :devise_mapping

  def resource_name
    :customer
  end
 
  def resource
    @resource ||= Customer.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:customer]
  end
  
  def index
    @services = Service.all
  end

  def show
    @service = Service.friendly.find params[:id]
  end

  def start
    @service = Service.friendly.find params[:id]
    @job = current_company.jobs.build service: @service
  end
end
