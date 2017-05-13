class AddStatusToSupportTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :support_tickets, :status, :integer, default: 0
  end
end
