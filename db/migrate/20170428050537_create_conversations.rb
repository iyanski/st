class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.references :job
      t.string  :topic
      t.timestamps
    end
  end
end
