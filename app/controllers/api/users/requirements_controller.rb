class Api::Users::RequirementsController < Api::UsersController
  def index
    @requirements = Service.find(params[:service_id]).requirements
  end

  def create
    @requirement = Service.find(params[:service_id]).requirements.build requirement_params
    unless @requirement.save
      render json: {error: @requirement.errors.full_messages.first}, status: 401
    end
  end

  def update
    @requirement = Service.find(params[:service_id]).requirements.where(id: params[:id]).first
    unless @requirement.update_attributes requirement_params
      render json: {error: @requirement.errors.full_messages.first}, status: 401
    end
  end

  def show
    @requirement = Service.find(params[:service_id]).requirements.where(id: params[:id]).first
  end

  def destroy
    @requirement = Service.find(params[:service_id]).requirements.where(id: params[:id]).first
    unless @requirement.destroy
      render json: {error: @requirement.errors.full_messages.first}, status: 401
    end
  end

  private

    def requirement_params
      params.require(:requirement).permit(:service_id, :description)
    end
end
