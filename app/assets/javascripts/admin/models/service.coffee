@app.factory "Service", [ "$resource", ($resource) ->
  Service = $resource Routes.api_users_services_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_users_service_path(':id')}
      update: {method: "PUT", url: Routes.api_users_service_path(':id')}
    }
  return Service
]