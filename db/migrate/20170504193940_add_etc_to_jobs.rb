class AddEtcToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :estimate, :float
    add_column :jobs, :etc, :integer, default: 0
  end
end
