class JobBroadcastJob < ApplicationJob
  queue_as :default

  def perform(job)
    ActionCable.server.broadcast "jobs", { job: job }
  end
end