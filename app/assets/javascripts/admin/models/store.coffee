@app.factory "Store", [ "$resource", ($resource) ->
  Store = $resource Routes.api_users_store_path(),
    { id: "@id" }
    {
      update: {method: "PUT", url: Routes.api_users_store_path(':id')}
    }
  return Store
]