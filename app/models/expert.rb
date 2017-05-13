class Expert < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  has_many :jobs
  has_many :payment_transactions
  has_one :expert_setting
  has_many :support_tickets
  after_create :generate_default_settings
  mount_uploader :avatar, MediaUploader

  def name
    [first_name, last_name].join(" ")
  end

  def sales
    {
      weekly: weekly_sales[0],
      monthly: monthly_sales[0],
      all: total_sales[0],
      total_tasks_count: payment_transactions.count
    }
  end

  private
    def generate_default_settings
      ExpertSetting.create(expert: self)
    end

    def weekly_sales
      self.payment_transactions.select("SUM(cost) as total").where(created_at: Date.today.beginning_of_week.to_time..Time.now.midnight)
    end

    def monthly_sales
      self.payment_transactions.select("SUM(cost) as total").where(created_at: Date.today.beginning_of_month.to_time..Time.now.midnight)
    end

    def total_sales
      self.payment_transactions.select("SUM(cost) as total").where(created_at: self.created_at..Time.now.midnight)
    end
end
