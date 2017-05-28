class JobsController < ApplicationController
  # before_filter :authenticate_customer!, only: [:create]
  def show
    session[:job_id] = params[:id]
    if params[:r] = "u"
      redirect_to "/app"
    elsif params[:r] = "e"
      redirect_to "/dashboard"
    else
      redirect_to root_url
    end
  end

  def create
    unless current_customer
      render json: {error: "Please sign-up to continue"}, status: 401
    else
      job = Job.new job_params
      job.customer = current_customer
      unless job.save
        render json: {error: job.errors.full_messages.first}, status: 401
      else
        render json: {success: "Job Posted"}
      end
    end
  end

  private

    def job_params
      params.require(:job).permit(:title, :description, :service_id)
    end
end
