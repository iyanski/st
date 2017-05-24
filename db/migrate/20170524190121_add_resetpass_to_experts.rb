class AddResetpassToExperts < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, :repass, :integer, default: 1
  end
end
