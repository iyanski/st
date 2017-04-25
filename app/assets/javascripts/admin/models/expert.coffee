@app.factory "Expert", [ "$resource", ($resource) ->
  Expert = $resource Routes.api_users_experts_path(),
    { 
      id: "@id"
    }
    {
      update: {method: "PUT", url: Routes.api_users_expert_path(':id')}
    }
  return Expert
]