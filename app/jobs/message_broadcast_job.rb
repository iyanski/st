class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(job, message, is_system_message, status, payload)
    ActionCable.server.broadcast "chats", { 
      message: {
        content: message,
        job_id: job,
        system: is_system_message,
        status: status,
        payload: payload
      }.squish 
    }
  end
end