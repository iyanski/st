class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :conversation
      t.references :user
      t.boolean :from_system, default: 0
      t.text  :content
      t.timestamps
    end
  end
end
