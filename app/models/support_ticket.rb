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

  def chat_to(sender, recipient, message)
    recipient = recipient
    sender = sender
    puts sender.inspect
    puts recipient.inspect
    # firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    # channel = "tickets/#{self.company_id}/#{id}/#{conversation.code}"
    # response = firebase.push(channel, {sender: sender.name, content: message, sender_id: sender.id, recipient_id: recipient.id, created_at: Time.now, sender_type: recipient.class.to_s})
    # UserMailer.chat(self, message, sender, recipient).deliver_later
  end

  private
    def generate_conversation
      self.conversation = self.job.create_conversation
      self.save
    end
end
