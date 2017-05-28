class AddShortDescriptionToService < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :short_description, :string, default: ""
    add_column :services, :tags, :string, default: ""
  end
end
