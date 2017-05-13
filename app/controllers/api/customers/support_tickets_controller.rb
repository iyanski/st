class Api::Customers::SupportTicketsController < Api::CustomersController
  def index
    @tickets = current_customer.support_tickets
  end

  def create
    @ticket = SupportTicket.new ticket_params
    @ticket.customer = current_customer
    unless @ticket.save
      render json: {error: @ticket.errors.full_messages.first}, status: 401
    end
  end

  private

    def ticket_params
      params.require(:support_ticket).permit(:job_id, :customer_id, :expert_id, :title, :description)
    end
end
