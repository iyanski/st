class Service < ApplicationRecord
  extend FriendlyId
  friendly_id :title, :use => :slugged
  mount_uploader :photo, MediaUploader
  
  belongs_to :company
  has_many :benefits
  has_many :requirements
  has_many :faqs

  validates :title, presence: true
  validates :description, presence: true
  validates :price, numericality: true
  validates :service_type, presence: true
end
