class Api::Experts::JobsController < Api::ExpertsController
  def index
    @jobs = current_expert.jobs
  end

  def show
    @job = current_customer.jobs.where(id: params[:id]).first()
    if @job.nil?
      render json: {error: "Job not found"}, status: 401
    end
  end

  def claim
    @job = Job.find(params[:id])
    unless @job.claim_by current_expert
      puts @job.inspect
      render json: {error: "Job not found"}, status: 401
    end
  end

  def unclaim
    @job = Job.find(params[:id])
    unless @job.unclaim_by current_expert
      puts @job.inspect
      render json: {error: "Job not found"}, status: 401
    end
  end

  def estimate
    @job = Job.find(params[:id])
    puts params[:job].inspect
    unless @job.estimates params[:job][:estimate], Date.strptime(params[:job][:starts_at], "%m/%d/%Y"), params[:job][:etc]
      render json: {error: "Job not found"}, status: 401
    end
  end

  def submit
    @job = Job.find(params[:id])
    unless @job.submit
      render json: {error: "Job not found"}, status: 401
    end
  end

  def chat
    @job = current_expert.jobs.where(id: params[:id]).first
    @job.chat_to @job.user, params[:content]
    render json: {content: params[:content]}
  end

  def upload
    @job = Job.find(params[:id])
    unless @job.attach params[:file], nil, current_expert
      render json: {error: @job.errors.full_messages.first}, status: 401
    end
  end

  private

    def job_params
      params.require(:job).permit(:title, :description, :category_id, :status)
    end
end
