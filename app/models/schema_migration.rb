class SchemaMigration < ApplicationRecord

  def self.heal
    Apartment::Tenant.switch!("public")
    schemas = SchemaMigration.all

    Company.pluck(:subdomain).each do |tenant|
      Apartment::Tenant.switch!(tenant)
      schemas.each do |schema|
          migration = SchemaMigration.find_by_version(schema.version)
          if migration.nil?
              SchemaMigration.create(:version => schema.version)
          end
      end
    end
  end
end
