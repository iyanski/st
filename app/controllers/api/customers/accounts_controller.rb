class Api::Customers::AccountsController < Api::CustomersController
  def update
    @customer = current_customer
    account = params[:account]

    unless account.nil?
      customer = Customer.find_for_authentication(email: current_customer.email)
      if customer.valid_password?(account[:current_password])
        customer.password = account[:password]
        customer.save
      end
    end

    unless @customer.update_attributes customer_params
      render json: {error: @customer.errors.full_messages.first}, status: 401
    else
      render json: @customer
    end
  end

  def upload
    @customer = current_customer
    unless params[:file].nil?
      puts params[:file].inspect
      @customer.avatar = params[:file]
    end
    unless @customer.save
      render json: {error: @customer.errors.full_messages.first}, status: 401
    end
  end

  private
    def customer_params
      params.require(:account).permit(:first_name, :last_name)
    end
end
