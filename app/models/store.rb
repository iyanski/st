class Store < ApplicationRecord
  belongs_to :company
  mount_uploader :cover, StoreCoverUploader
  mount_uploader :logo, LogoUploader

end
