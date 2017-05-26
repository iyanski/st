class AddStatusToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :status, :integer, default: 0
  end
end
