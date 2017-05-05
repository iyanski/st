class CreatePaymentTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_transactions do |t|
      t.references :company
      t.references :job
      t.references :customer
      t.references :expert
      t.float    :cost
      t.float    :commission
      t.float    :fee
      t.datetime :release_at
      t.timestamps
    end
  end
end

