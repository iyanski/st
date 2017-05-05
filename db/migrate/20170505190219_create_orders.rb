class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :customer
      t.references :job
      t.string   :ip
      t.string   :express_token
      t.string   :express_payer_id
      t.float    :price
      t.boolean  :status
      t.timestamps
    end
  end
end








