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

  def validated?
    true
  end
end
