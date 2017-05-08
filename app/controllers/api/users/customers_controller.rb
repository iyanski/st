class Api::Users::CustomersController < Api::UsersController
  def index
    @customers = Customer.all.order("created_at DESC")
  end
  
  def show
    @customer = Customer.find(params[:id])
  end

  def sales
    customer = Customer.find(params[:id])
    render json: {sales: customer.sales}
  end

  def transactions
    customer = Customer.find(params[:id])
    @transactions = customer.payment_transactions
  end
end