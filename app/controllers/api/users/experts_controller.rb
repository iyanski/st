class Api::Users::ExpertsController < Api::UsersController
  def index
    @experts = Expert.all.order("created_at DESC")
  end

  def create
    password = SecureRandom.hex(8)
    @expert = Expert.new email: expert_params[:email], first_name: expert_params[:first_name], last_name: expert_params[:last_name], company_id: current_company.id, password: password, password_confirmation: password
    @expert.company = current_company
    if @expert.save
      UserMailer.send_expert_registration_information(@expert, password, "http://#{request.host_with_port}/experts/sign_in").deliver
    else
      render json: {error: @expert.errors.full_messages.first}, status: 401
    end
  end

  def update
    @expert = current_company.experts.where(id: params[:id]).first.benefits.where(id: params[:id]).first
    unless @expert.update_attributes update_expert_params
      render json: {error: @expert.errors.full_messages.first}, status: 401
    end
  end

  def show
    @expert = current_company.experts.where(id: params[:id]).first
  end

  private
    def expert_params
      params.require(:expert).permit(:email, :first_name, :last_name)
    end

    def update_expert_params
      params.require(:expert).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
