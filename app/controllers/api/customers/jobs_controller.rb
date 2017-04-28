class Api::Customers::JobsController < Api::CustomersController
  skip_before_action :verify_authenticity_token, :only => :pay
  def index
    # @@data = File.read("#{Rails.root}/public/emails.json")
    @jobs = current_customer.jobs
    # render json: @@data
  end

  def create
    @job = current_customer.jobs.build job_params
    puts (job_params[:status].to_i == 1).inspect
    if job_params[:status].to_i == 1
      puts "========================"
      unless @job.save_and_publish
        render json: {error: @job.errors.full_messages.first}, status: 401
      end
    else
      unless @job.save
        render json: {error: @job.errors.full_messages.first}, status: 401
      end
    end
  end

  def show
    @job = current_customer.jobs.where(id: params[:id]).first()
  end

  def update
    @job = current_customer.jobs.where(id: params[:id]).first()
    unless @job.update_attributes job_params
      render json: {error: "Job not found"}, status: 401
    end
  end

  def publish
    @job = current_customer.jobs.where(id: params[:id]).first
    unless @job.publish
      render json: {error: "Job not found"}, status: 401
    end
  end

  def unpublish
    @job = current_customer.jobs.where(id: params[:id]).first
    unless @job.unpublish
      render json: {error: "Job not found"}, status: 401
    end
  end

  def decline
    @job = current_customer.jobs.where(id: params[:id]).first
    unless @job.decline
      render json: {error: "Job not found"}, status: 401
    else
      render :show
    end
  end

  def complete
    @job = current_customer.jobs.where(id: params[:id]).first
    unless @job.complete
      render json: {error: "Job not found"}, status: 401
    else
      render :show
    end
  end

  def cancel
    @job = current_customer.jobs.where(id: params[:id]).first
    unless @job.cancel
      render json: {error: "Job not found"}, status: 401
    else
      render json: {message: "Job successfully removed"}
    end
  end

  def chat
    @job = current_customer.jobs.where(id: params[:id]).first
    @job.chat_to @job.expert, params[:content]
    render json: {content: params[:content]}
  end

  def pay
    require "stripe"
    Stripe.api_key = "sk_test_w4DScZiWDQFiNubpgAO3z45g"
    job = current_customer.jobs.where(id: params[:id]).first
    rate = 59
    if !job.nil?
      amount = (job.estimate * rate * 100).to_i
      charge = Stripe::Charge.create(
        :amount => amount,
        :currency => "usd",
        :source => params[:stripeToken],
        :description => "Charge for Job(#{job.id})",
        :metadata => { id: job.id, job: job.title }
      )
      if charge.paid && job.approved
        PaymentTransaction.create_for_(job)
        redirect_to root_url + "/#/job/#{job.id}"
      end
    end
  end

  def upload
    @job = Job.find(params[:id])
    unless @job.attach params[:file], current_user
      render json: {error: @job.errors.full_messages.first}, status: 401
    end
  end

  private

    def job_params
      params.require(:job).permit(:title, :description, :category_id, :status, :service_id)
    end
end
