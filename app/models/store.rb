class Store < ApplicationRecord
  belongs_to :company
  mount_uploader :cover, MediaUploader

  def published?
    !title.nil?
  end
end
