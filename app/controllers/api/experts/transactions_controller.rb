class Api::Experts::TransactionsController < Api::ExpertsController
  def index
    @transactions = current_expert.payment_transactions
  end
end
