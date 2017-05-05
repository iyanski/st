class AddCompanyToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :company
  end
end
