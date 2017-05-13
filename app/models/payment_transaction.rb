class PaymentTransaction < ApplicationRecord
  belongs_to :job
  belongs_to :company
  belongs_to :expert
  belongs_to :customer
  validates :cost, presence: true, numericality: true
  validates :commission, presence: true, numericality: true
  validates :fee, presence: true, numericality: true

  def self.create_for_(job)
    transaction = self.new
    transaction.job = job
    transaction.expert = job.expert
    transaction.company = job.company
    transaction.customer = job.customer
    transaction.fee = job.service.price * (100 - job.service.experts_rate) / 100
    transaction.cost = (job.estimate * job.service.price)
    transaction.commission = transaction.cost - transaction.fee
    transaction.service_type = job.service.service_type

    if transaction.service_type == 0
      transaction.qty = job.estimate
    elsif transaction.service_type == 1
      transaction.qty = 1
    end

    if transaction.save
      transaction.job.orders.last.update_attributes(status: 1)
    end

    transaction
  end

  # For experts
  def floating_balance
    if release_at > Time.now
      self.cost * (job.service.experts_rate / 100)
    else
      0.00
    end
  end

  def available_balance
    if release_at <= Time.now
      self.cost * (job.service.experts_rate / 100)
    else
      0.00
    end
  end

  def earnings
    self.cost * (job.service.experts_rate / 100)
  end

  def release_in_ days
    self.release_at = Time.now + days
    self.save
  end
end