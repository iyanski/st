class CreateCustomerSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_settings do |t|
      t.references :customer
      t.boolean :email_when_expert_claims, default: true
      t.boolean :email_when_expert_waives_claims, default: true
      t.boolean :email_when_expert_sends_estimate, default: true
      t.boolean :email_when_expert_cancels_estimate, default: true
      t.boolean :email_when_expert_submits_work, default: true
      t.timestamps
    end
  end
end
