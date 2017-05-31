@app.factory "Message", [ "$resource", ($resource) ->
  Message = $resource Routes.root_path(),
    {id: "@id"}
    { chat: {method: "POST", url: Routes.chat_api_users_support_ticket_path(':id')} }
  return Message
]

@app.factory "ChatMessage", [ "$resource", ($resource) ->
  ChatMessage = $resource Routes.root_path(),
    {id: "@id"}
    { chat: {method: "POST", url: Routes.chat_api_users_job_path(':id')} }
  return ChatMessage
]