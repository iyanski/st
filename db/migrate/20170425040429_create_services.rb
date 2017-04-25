class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.references :company
      t.string   "title"
      t.text     "description",  limit: 65535
      t.float    "price",        limit: 24
      t.integer  "service_type",               default: 0
      t.string   "slug"
      t.string   "photo"
      t.float    "platform_fee", limit: 24,    default: 13.0
      t.float    "experts_rate", limit: 24,    default: 75.0
      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
