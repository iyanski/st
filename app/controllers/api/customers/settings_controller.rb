class Api::Customers::SettingsController < Api::CustomersController
  def update
    @settings = current_customer.customer_setting
    unless @settings.update_attributes settings_params
      render json: {error: @settings.errors.full_messages.first}, status: 401
    end
  end

  private
    def settings_params
      params.require(:setting).permit(:email_when_expert_claims, :email_when_expert_waives_claims, :email_when_expert_sends_estimate, :email_when_expert_cancels_estimate, :email_when_expert_submits_work)
    end
end
