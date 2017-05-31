@app.factory "Ticket", [ "$resource", ($resource) ->
  Ticket = $resource Routes.api_experts_support_tickets_path(),
    { id: "@id" }
    {
      update: {method: "PUT", url: Routes.api_experts_support_ticket_path(':id')}
    }
  return Ticket
]