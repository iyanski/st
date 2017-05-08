class Api::Users::JobsController < Api::UsersController
  def index
    unless params[:expert_id].nil?
      @jobs = Job.where(expert_id: params[:expert_id])
    else
      @jobs = Job.all
    end
  end

  def show
    @job = Job.find params[:id]
  end
end
