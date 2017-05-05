class AddStartsAtToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :starts_at, :datetime
  end
end
