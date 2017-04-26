class CreateExpertSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_settings do |t|
      t.references :expert
      t.boolean :email_when_new_job_arrives, default: true
      t.boolean :email_when_user_approves_estimate, default: true
      t.boolean :email_when_user_approves_job, default: true
      t.boolean :email_when_user_cancels_claimed_job, default: true
      t.boolean :email_when_user_cancels_estimated_job, default: true
      t.boolean :email_when_user_cancels_ongoing_job, default: true
      t.timestamps
    end
  end
end
