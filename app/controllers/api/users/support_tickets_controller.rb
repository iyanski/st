class Api::Users::SupportTicketsController < Api::UsersController
  def index
    @tickets = SupportTicket.all.order("updated_at DESC")
  end

  def chat
    recipient = params[:recipient_type] == "Customer" ? Customer.find(params[:recipient_id]) : Expert.find(params[:recipient_id])
    @ticket = SupportTicket.where(id: params[:id]).first
    @ticket.chat current_user, recipient, params[:content], current_company.id
    render json: {content: params[:content]}
  end
end
