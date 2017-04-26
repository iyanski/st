class Expert < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  has_many :jobs
  has_one :expert_setting
  after_create :generate_default_settings
  mount_uploader :avatar, MediaUploader

  def name
    [first_name, last_name].join(" ")
  end

  private
    def generate_default_settings
      ExpertSetting.create(expert: self)
    end
end
