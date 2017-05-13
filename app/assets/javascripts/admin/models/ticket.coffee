@app.factory "Ticket", [ "$resource", ($resource) ->
  Ticket = $resource Routes.api_users_support_tickets_path(),
    { id: "@id" }
    {
      update: {method: "PUT", url: Routes.api_users_support_ticket_path(':id')}
    }
  return Ticket
]