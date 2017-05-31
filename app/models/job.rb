class Job < ApplicationRecord
  has_one :payment_transaction
  belongs_to :customer
  belongs_to :expert
  belongs_to :company
  # belongs_to :category
  has_many :orders
  belongs_to :company
  belongs_to :service
  has_many :job_attachments
  validates :title, presence: true
  has_many :conversations
  after_create_commit :generate_conversation

  scope :pending, -> {
    where(expert_id: nil, status: 1).order("created_at DESC")
  }

  default_scope ->{
    where(closed_at: nil)
  }

  def code
    id + 699
  end

  def attach(file, customer = nil, expert = nil)
    attachment = JobAttachment.new
    attachment.job = self
    attachment.customer = customer
    attachment.expert = expert
    sender = customer if customer
    sender = expert if expert
    attachment.file = file
    if attachment.save

      firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
      
      if customer && expert
        message = "attached a file"
        channel = "messages/#{self.id}/#{self.expert.id}/#{self.customer.id}"
        response = firebase.push(channel, {sender: sender.name, content: message, created_at: Time.now, system: true})
      end

      channel = "updates/#{self.company_id}"
      puts channel
      response = firebase.push(channel, {sender: sender.name, job_id: self.id, created_at: Time.now, system: true, expert_id: sender.id, customer_id: self.customer.id})
    end
  end

  def price
    estimate * service.price
  end

  def price_in_cents
    estimate * service.price * 100
  end

  def publish
    self.save_and_publish
  end

  def unpublish
    self.update_attributes(status: 0)
  end

  def conversation
    if conversations.length == 1
      conversations.first
    else
      conversations.last
    end
  end

  def save_and_publish
    self.status = 1
    if self.published_at.nil?
      self.published_at = Time.now
      self.save
      message = "posted a new job request"
      firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
      channel = "jobs/#{company.id}/#{id}"
      response = firebase.set(channel, {sender: self.customer.name, job_id: self.id, content: message, created_at: Time.now, system: true})
    else
      self.save
    end
  end

  def claim_by(expert)
    puts "==============================================================="
    puts self.company.inspect
    puts "==============================================================="
    self.update_attributes(status: 2, claimed_at: Time.new, expert_id: expert.id)
    message = "claimed this job"
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, created_at: Time.now, system: true, expert_id: self.expert.id, customer_id: self.customer.id})

    UserMailer.claim(self).deliver_later
  end

  def unclaim_by(expert)
    message = "unclaimed this job"
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, created_at: Time.now, system: true, expert_id: self.expert.id, customer_id: self.customer.id})
    
    self.update_attributes(status: 1, claimed_at: Time.new, expert_id: nil)

    UserMailer.unclaim(self, expert).deliver_later
  end

  def estimates(estimate, starts_at, etc)
    self.update_attributes(status: 3, estimated_at: Time.new, starts_at: starts_at, etc: etc, estimate: estimate)
    message = "sent an estimate"
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, customer_id: self.customer.id})

    UserMailer.estimates(self).deliver_later
  end

  def cancel_estimate
    expert = self.expert
    message = "cancelled estimate"
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: expert.id, customer_id: self.customer.id})

    UserMailer.cancel_estimates(self, expert).deliver_later
    self.update_attributes(status: 1, estimated_at: nil, starts_at: nil, etc: nil, estimate: 0, expert_id: nil)
  end

  def submit
    self.update_attributes(status: 5, estimated_at: Time.new, starts_at: starts_at, etc: etc, estimate: estimate)
    message = "submitted for review"
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.customer.id})

    UserMailer.submit(self).deliver_later
  end

  def decline
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    message = "declined your estimate"
    response = firebase.push(channel, {sender: self.customer.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.customer.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.customer.id})

    expert = self.expert.dup
    if self.update_attributes(status: 1, estimated_at: nil, claimed_at: nil, starts_at: nil, etc: 0, estimate: nil, expert_id: nil)
      UserMailer.decline(self, expert).deliver_later
    end
  end

  def cancel
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    unless expert.nil?
      channel = "messages/#{self.id}/#{self.expert.id}/#{self.customer.id}"
      message = "cancelled the job"
      response = firebase.push(channel, {sender: self.customer.name, content: message, created_at: Time.now, system: true})
    end

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.customer.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.try(:expert).try(:id), customer_id: self.customer.id})
    
    unless expert.nil?
      UserMailer.cancel(self).deliver_later
    end

    self.update_attributes(status: 0, estimated_at: nil, claimed_at: nil, starts_at: nil, etc: 0, estimate: nil, expert_id: nil, closed_at: Time.now)
  end

  def approved
    self.update_attributes(status: 4, accepted_at: Time.now)
    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    message = "approved the estimate"
    response = firebase.push(channel, {sender: self.customer.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.customer.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.customer.id})

    UserMailer.approved(self).deliver_later
  end

  def complete
    self.payment_transaction.release_in_ 7.days
    self.update_attributes(status: 6, accepted_at: Time.now)

    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    message = "marked the job complete"
    response = firebase.push(channel, {sender: self.customer.name, content: message, created_at: Time.now, system: true})

    channel = "updates/#{self.company_id}"
    response = firebase.push(channel, {sender: self.customer.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.customer.id})

    UserMailer.completed(self).deliver_later
  end

  def chat_to(recipient, message)
    recipient_type = recipient.class.to_s
    if recipient_type == "Expert"
      recipient = expert
      sender = customer
      sender_type = "Customer"
    elsif recipient_type == "Customer"
      recipient = customer
      sender = expert
      sender_type = "Expert"
    end

    firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
    channel = "messages/#{self.company_id}/#{id}/#{conversation.code}"
    response = firebase.push(channel, {sender: sender.name, content: message, sender_id: sender.id, recipient_id: recipient.id, created_at: Time.now, sender_type: sender_type})

    UserMailer.chat(self, message, sender, recipient).deliver_later
  end

  def create_conversation
    Conversation.create(topic: title, job_id: id)
  end

  private
    def generate_conversation
      Conversation.create(topic: title, job_id: id)
    end

    def broadcast_job
      JobBroadcastJob.perform_now(self)
    end
end
