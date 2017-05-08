@app.factory "Expert", [ "$resource", ($resource) ->
  Expert = $resource Routes.api_users_experts_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_users_expert_path(':id')}
      update: {method: "PUT", url: Routes.api_users_expert_path(':id')}
      sales: {method: "GET", url: Routes.sales_api_users_expert_path(':id')}
      transactions: {method: "GET", url: Routes.transactions_api_users_expert_path(':id'), isArray: true}
    }
  return Expert
]