class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  has_many :jobs
  has_one :customer_setting
  after_create :generate_default_settings

  def name
    [first_name, last_name].join(" ")
  end
  private
    def generate_default_settings
      CustomerSetting.create(customer: self)
    end
end
