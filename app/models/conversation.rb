class Conversation < ApplicationRecord
  belongs_to :job
  has_many :messages
  validates :topic, presence: true
  before_create :generate_random_code

  private
    def generate_random_code
      self.code = SecureRandom.hex(16)
    end
end
