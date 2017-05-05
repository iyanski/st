App.job = App.cable.subscriptions.create "JobChannel",
  connected: ->
    console.log "Called when the subscription is ready for use on the server"

  disconnected: ->
    console.log "Called when the subscription has been terminated by the server"

  received: (data) ->
    console.log "Got the new job"
    console.log data

  # send_message: (message)->
  #   @perform "send_message", { message: message }