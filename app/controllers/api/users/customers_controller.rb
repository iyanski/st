class Api::Users::CustomersController < Api::UsersController
  def index
    @customers = Customer.all.order("created_at DESC")
  end
end