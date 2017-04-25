class CreateRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :requirements do |t|
      t.references :service
      t.string   :description
      t.timestamps
    end
  end
end
