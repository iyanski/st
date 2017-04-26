@app.factory "ChatService", [ "$resource", ($resource) ->
  ChatService = firebase.database()
  return ChatService
]