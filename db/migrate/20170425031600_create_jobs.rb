class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.references  :customer
      t.references  :expert
      t.references  :category
      t.string      :title
      t.text        :description
      t.integer     :status, default: 0 # {0: draft, 1: published, 2: claimed, 3: estimated, 4: accepted, 5: submitted, 6: completed, 7: closed}
      t.datetime    :published_at
      t.datetime    :claimed_at
      t.datetime    :estimated_at
      t.datetime    :accepted_at
      t.datetime    :submitted_at
      t.datetime    :completed_at
      t.datetime    :closed_at
      t.timestamps
    end
  end
end
