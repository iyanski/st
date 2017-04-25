class Job < ApplicationRecord
  # has_one :payment_transaction
  belongs_to :customer
  belongs_to :expert
  # belongs_to :category
  belongs_to :company
  # has_many :job_attachments
  # validates :title, presence: true

  # # scope :pending, -> {
  # #   where(published_at: nil, expert_id: nil).order("created_at DESC")
  # # }

  # scope :pending, -> {
  #   where(status: 1, expert_id: nil).order("created_at DESC")
  # }

  # def code
  #   id + 699
  # end

  # def attach(file, user = nil, expert = nil)
  #   attachment = JobAttachment.new
  #   attachment.job = self
  #   attachment.user = user unless user.nil?
  #   attachment.expert = expert unless expert.nil?
  #   attachment.file = file
  #   attachment.save
  # end

  # def price
  #   estimate * 59
  # end

  # def price_in_cents
  #   estimate * 59 * 100
  # end

  # def publish
  #   self.save_and_publish
  # end

  # def unpublish
  #   self.update_attributes(status: 0)
  # end

  # def save_and_publish
  #   self.status = 1
  #   if self.published_at.nil?
  #     self.published_at = Time.now
  #     self.save
  #     message = "posted a new job request"
  #     firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #     channel = "jobs/#{id}"
  #     response = firebase.set(channel, {sender: self.user.name, job_id: self.id, content: message, created_at: Time.now, system: true})
  #   else
  #     self.save
  #   end
  # end

  # def claim_by(expert)
  #   self.update_attributes(status: 2, claimed_at: Time.new, expert_id: expert.id)
  #   message = "claimed this job"
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})

  #   UserMailer.claim(self).deliver
  # end

  # def estimates(estimate, starts_at, etc)
  #   self.update_attributes(status: 3, estimated_at: Time.new, starts_at: starts_at, etc: etc, estimate: estimate)
  #   message = "sent an estimate"
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})

  #   UserMailer.estimates(self).deliver
  # end

  # def submit
  #   self.update_attributes(status: 5, estimated_at: Time.new, starts_at: starts_at, etc: etc, estimate: estimate)
  #   message = "submitted for review"
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   response = firebase.push(channel, {sender: self.expert.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.expert.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})

  #   UserMailer.submit(self).deliver
  # end

  # def decline
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   message = "declined your estimate"
  #   response = firebase.push(channel, {sender: self.user.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.user.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})
  #   self.update_attributes(status: 1, estimated_at: nil, claimed_at: nil, starts_at: nil, etc: 0, estimate: nil, expert_id: nil)

  #   UserMailer.decline(self).deliver
  # end

  # def cancel
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   message = "cancelled the job"
  #   response = firebase.push(channel, {sender: self.user.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.user.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})
  #   self.update_attributes(status: 1, estimated_at: nil, claimed_at: nil, starts_at: nil, etc: 0, estimate: nil, expert_id: nil)

  #   UserMailer.cancel(self).deliver
  # end

  # def approved
  #   self.update_attributes(status: 4, accepted_at: Time.now)
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   message = "approved the estimate"
  #   response = firebase.push(channel, {sender: self.user.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.user.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})

  #   UserMailer.approved(self).deliver
  # end

  # def complete
  #   self.update_attributes(status: 6, accepted_at: Time.now)
  #   self.payment_transaction.release_in_ 7.days
  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   message = "marked the job complete"
  #   response = firebase.push(channel, {sender: self.user.name, content: message, created_at: Time.now, system: true})

  #   channel = "updates"
  #   response = firebase.push(channel, {sender: self.user.name, job_id: self.id, content: message, created_at: Time.now, system: true, expert_id: self.expert.id, user_id: self.user.id})

  #   UserMailer.completed(self).deliver
  # end

  # def chat_to(recipient, message)
  #   recipient_type = recipient.class.to_s
  #   if recipient_type == "Expert"
  #     recipient = expert
  #     sender = user
  #     sender_type = "User"
  #   elsif recipient_type == "User"
  #     recipient = user
  #     sender = expert
  #     sender_type = "Expert"
  #   end

  #   firebase = Firebase::Client.new(ENV["firebase_base_uri"], ENV["firebase_secret_key"])
  #   channel = "messages/#{id}/#{expert.id}/#{user.id}"
  #   response = firebase.push(channel, {sender: sender.name, content: message, sender_id: sender.id, recipient_id: recipient.id, created_at: Time.now, sender_type: sender_type})

  #   UserMailer.chat(self, message, sender, recipient).deliver
  # end
end
