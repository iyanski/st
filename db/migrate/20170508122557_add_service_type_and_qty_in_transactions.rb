class AddServiceTypeAndQtyInTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :payment_transactions, :qty, :float
    add_column :payment_transactions, :service_type, :integer
  end
end
