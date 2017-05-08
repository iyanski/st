class AddCodeToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :code, :string
  end
end
