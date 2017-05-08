class Api::Users::TransactionsController < Api::UsersController
  def index
    @transactions = PaymentTransaction.all
  end
end
