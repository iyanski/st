class Api::Experts::AccountsController < Api::ExpertsController
  def update
    @expert = current_expert
    account = params[:account]

    unless account.nil?
      expert = Expert.find_for_authentication(email: current_expert.email)
      if expert.valid_password?(account[:current_password])
        expert.password = account[:password]
        expert.save
      end
    end

    unless @expert.update_attributes expert_params
      render json: {error: @expert.errors.full_messages.first}, status: 401
    else
      render json: @expert
    end
  end

  def upload
    @expert = current_expert
    unless params[:file].nil?
      puts params[:file].inspect
      @expert.avatar = params[:file]
    end
    unless @expert.save
      render json: {error: @expert.errors.full_messages.first}, status: 401
    end
  end

  private
    def expert_params
      params.require(:account).permit(:first_name, :last_name)
    end
end
