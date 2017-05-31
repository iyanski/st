class SupportTicket < ApplicationRecord
  belongs_to :job
  belongs_to :customer
  belongs_to :expert
  belongs_to :conversation
  validates :title, presence: true
  validates :description, presence: true

  after_create :generate_conversation

  def code
    id + 299
  end

  def chat(sender, recipient, message, company_id)
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "tickets/#{company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: sender.name, content: message, sender_id: sender.id, recipient_id: recipient.id, created_at: Time.now, sender_type: sender.class.to_s})
    puts response.inspect
    # UserMailer.chat(self, message, sender, recipient).deliver_later
  end

  private
    def generate_conversation
      self.conversation = self.job.create_conversation
      self.save
    end
end
