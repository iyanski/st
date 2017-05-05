class JobAttachment < ApplicationRecord
  belongs_to :customer
  belongs_to :expert
  belongs_to :job
  mount_uploader :file, AttachmentUploader
  attr_accessor :is_thumbnable
end
