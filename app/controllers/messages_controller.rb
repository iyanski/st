class MessagesController < ApplicationController
  def create
    message = Message.create message_params
    ActionCable.server.broadcast "chat", {
      message: MessagesController
    }
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
