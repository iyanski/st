@app.factory "Message", [ "$resource", ($resource) ->
  Message = $resource Routes.root_path(),
    {id: "@id"}
    { chat: {method: "POST", url: Routes.chat_api_experts_support_ticket_path(':id')} }
  return Message
]