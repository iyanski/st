class Company < ApplicationRecord
  # has_many :users
  # has_many :experts
  has_many :jobs
  # has_many :categories
  # has_many :signups
  # has_many :payment_transactions
  has_many :users
  # has_many :customers
  # has_many :experts
  # has_many :services
  # has_many :jobs
  has_one :store
  validates :subdomain, presence: true
  validates :subdomain, uniqueness: true
  validates :domain, uniqueness: true
  after_create :create_tenant, :create_store

  def validated?
    true
  end

  private
    def create_tenant
      puts "===================================================="
      puts "Apartment::Tenant.create(company.subdomain)"
      Apartment::Tenant.create(subdomain)
      puts "DB_NAME=#{subdomain} bundle exec rake db:migrate"
      # system("DB_NAME=#{subdomain} bundle exec rake db:migrate")
      puts "===================================================="
    end

    def create_store
      Store.create
    end
end
