class ServicesController < ApplicationController
  layout 'storepage'
  def index
    @services = Service.all
  end

  def show
    @service = Service.friendly.find params[:id]
  end
end
