class JobChannel < ApplicationCable::Channel
  def subscribed
    stream_from "jobs"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def send_message(data)
  #   JobBroadcastJob.perform_later(data)
  # end
end
