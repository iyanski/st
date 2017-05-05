class CreateJobAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :job_attachments do |t|
      t.references :customer
      t.references :expert
      t.references :job
      t.string :file
      t.timestamps
    end
  end
end
