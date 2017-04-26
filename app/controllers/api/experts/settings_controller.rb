class Api::Experts::SettingsController < Api::ExpertsController
  def update
    @settings = current_expert.expert_setting
    unless @settings.update_attributes settings_params
      render json: {error: @settings.errors.full_messages.first}, status: 401
    end
  end

  private
    def settings_params
      params.require(:setting).permit(:email_when_new_job_arrives, :email_when_user_approves_estimate, :email_when_user_approves_job, :email_when_user_cancels_claimed_job, :email_when_user_cancels_estimated_job, :email_when_user_cancels_ongoing_job)
    end
end