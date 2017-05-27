class Api::Users::BenefitsController < Api::UsersController
  def index
    @benefits = Service.find(params[:service_id]).benefits
  end

  def create
    @benefit = Service.find(params[:service_id]).benefits.build benefit_params
    unless @benefit.save
      render json: {error: @benefit.error.full_messages.first}, status: 401
    end
  end

  def update
    @benefit = Service.find(params[:service_id]).benefits.where(id: params[:id]).first
    unless @benefit.update_attributes benefit_params
      render json: {error: @benefit.error.full_messages.first}, status: 401
    end
  end

  def show
    @benefit = Service.find(params[:service_id]).benefits.where(id: params[:id]).first
  end

  def destroy
    @benefit = Service.find(params[:service_id]).benefits.where(id: params[:id]).first
    unless @benefit.destroy
      render json: {error: @benefit.error.full_messages.first}, status: 401
    end
  end

  private

    def benefit_params
      params.require(:benefit).permit(:service_id, :description)
    end
end
