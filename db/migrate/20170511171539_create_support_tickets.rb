class CreateSupportTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :support_tickets do |t|
      t.references :job
      t.references :conversation
      t.references :customer
      t.references :expert
      t.string  :title
      t.text    :description
      t.timestamps
    end
  end
end
