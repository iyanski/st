class AddServiceToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :service
  end
end
