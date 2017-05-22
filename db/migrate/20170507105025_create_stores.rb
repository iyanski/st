class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.references :company
      t.string  :title
      t.string  :tagline
      t.string  :description
      t.string  :cover
      t.string  :logo
      t.string  :facebook
      t.string  :twitter
      t.string  :pinterest
      t.string  :google
      t.string  :contact_email
      t.string  :support_email
      t.timestamps
    end
  end
end
