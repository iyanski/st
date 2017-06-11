class Company < ApplicationRecord
  # has_many :users
  # has_many :experts
  has_many :jobs
  # has_many :categories
  # has_many :signups
  # has_many :payment_transactions
  has_one :user
  # has_many :customers
  # has_many :experts
  # has_many :services
  # has_many :jobs
  validates :subdomain, presence: true
  validates :subdomain, uniqueness: true
  validates :domain, uniqueness: true
  after_create :create_tenant, :create_store

  def store
    Store.first
  end

  def validated?
    true
  end

  private
    def create_tenant
      Apartment::Tenant.create(domain)
    end

    def create_store
      Store.create
    end
end
