@app.factory "Store", [ "$resource", ($resource) ->
  Store = $resource Routes.api_users_store_path()
  return Store
]