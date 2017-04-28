class Api::Users::ServicesController < Api::UsersController

  def index
    @services = Service.all
  end

  def create
    @service = Service.new service_params
    unless @service.save
      render json: {error: @service.errors.full_messages.first}, status: 401
    end
  end

  def update
    @service = Servie.where(id: params[:id]).first
    unless @service.update_attributes service_params
      render json: {error: @service.errors.full_messages.first}, status: 401
    end
  end

  def show
    @service = Service.find params[:id]
  end

  def upload
    @service = Service.find params[:id]
    unless params[:file].nil?
      @service.photo = params[:file]
    end
    unless @service.save
      render json: {error: @service.errors.full_messages.first}, status: 401
    end
  end

  def destroy
    @service = Service.find params[:id]
    @service.deleted_at = Time.now
    unless @service.save
      render json: {error: @service.errors.full_messages.first}, status: 401
    end
  end

  private

    def service_params
      params.require(:service).permit(:company_id, :title, :description, :price, :service_type, :experts_rate)
    end
end