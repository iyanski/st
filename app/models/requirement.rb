class Requirement < ApplicationRecord
  validates :description, presence: true
end
