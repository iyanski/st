class Service < ApplicationRecord
  extend FriendlyId
  friendly_id :title, :use => :slugged
  mount_uploader :photo, MediaUploader
  validates :title, presence: true
  validates :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 20.00}
  validates :platform_fee, numericality: {greater_than_or_equal_to: 13.00}
  validates :experts_rate, numericality: {greater_than_or_equal_to: 50.00}
  
  # belongs_to :company
  has_many :jobs
  has_many :benefits
  has_many :requirements
  has_many :faqs

  validates :title, presence: true
  validates :description, presence: true
  validates :price, numericality: true
  validates :service_type, presence: true

  def unit
    unit = Array.new
    unit[1] = "Hour"
    unit[2] = "Day"
    unit[3] = "Week"
    unit[4] = "Month"
    unit[5] = "Page"
    unit[6] = "Trip"
    unit[7] = "Job"
    unit[8] = "Task"
    unit[service_type]
  end
end
