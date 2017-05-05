class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :content, presence: true
  after_create_commit { MessageBroadcastJob.perform_later(self, nil, nil, nil) }
end
