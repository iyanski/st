class Store < ApplicationRecord
  belongs_to :company
  mount_uploader :cover, StoreCoverUploader
  mount_uploader :cover, LogoUploader

  def published?
    !title.nil?
  end
end
