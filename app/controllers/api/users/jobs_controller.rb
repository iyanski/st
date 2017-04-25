class Api::Users::JobsController < Api::UsersController
  def index
    @jobs = Job.all
  end

  def show
    @job = Job.where(id: params[:id]).first()
  end
end
