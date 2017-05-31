class Api::Experts::SupportTicketsController < Api::ExpertsController
  def index
    @tickets = current_expert.support_tickets
  end

  def create
    @ticket = SupportTicket.new ticket_params
    @ticket.expert = current_expert
    unless @ticket.save
      render json: {error: @ticket.errors.full_messages.first}, status: 401
    end
  end

  def chat
    recipient = current_company.user
    @ticket = current_expert.support_tickets.where(id: params[:id]).first
    @ticket.chat current_expert, recipient, params[:content], current_company.id
    render json: {content: params[:content]}
  end

  private

    def ticket_params
      params.require(:support_ticket).permit(:job_id, :customer_id, :expert_id, :title, :description)
    end
end
