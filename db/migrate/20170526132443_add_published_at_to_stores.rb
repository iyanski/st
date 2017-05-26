class AddPublishedAtToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :is_published, :boolean, default: false
  end
end
