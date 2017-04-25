@app.factory "Customer", [ "$resource", ($resource) ->
  Customer = $resource Routes.api_users_customers_path(),
    { 
      id: "@id"
    }
  return Customer
]