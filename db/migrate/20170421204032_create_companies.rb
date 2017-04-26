class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string   :name
      t.string   :domain
      t.string   :subdomain
      t.string   :address
      t.string   :address2
      t.string   :city
      t.string   :country
      t.string   :postal_code
      t.string   :contact_no
      t.string   :website
      t.string   :blog
      t.string   :logo
      t.timestamps
    end
  end
end
