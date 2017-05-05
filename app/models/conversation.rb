class Conversation < ApplicationRecord
  belongs_to :job
  has_many :messages
  validates :topic, presence: true
end
