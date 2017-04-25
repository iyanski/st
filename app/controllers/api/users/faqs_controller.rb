class Api::Users::FaqsController < Api::UsersController
  def index
    @faqs = Service.find(params[:service_id]).faqs
  end

  def create
    @faq = Service.find(params[:service_id]).faqs.build requirement_params
    unless @faq.save
      render json: {error: @faq.errors.full_messages.first}, status: 401
    end
  end

  def update
    @faq = Service.find(params[:service_id]).faqs.where(id: params[:id]).first
    unless @faq.update_attributes requirement_params
      render json: {error: @faq.errors.full_messages.first}, status: 401
    end
  end

  def show
    @faq = Service.find(params[:service_id]).faqs.where(id: params[:id]).first
  end

  def destroy
    @faq = Service.find(params[:service_id]).faqs.where(id: params[:id]).first
    @faq.deleted_at = Time.now
    unless @faq.save
      render json: {error: @faq.errors.full_messages.first}, status: 401
    end
  end

  private

    def requirement_params
      params.require(:faq).permit(:service_id, :question, :answer)
    end
end
