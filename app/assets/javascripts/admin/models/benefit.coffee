@app.factory "Benefit", [ "$resource", ($resource) ->
  Benefit = $resource Routes.api_users_service_benefits_path(':service_id'),
    { 
      id: "@id"
      service_id: "@service_id"
    }
    {
      get: {method: "GET", url: Routes.api_users_service_benefit_path(':service_id', ':id')}
      update: {method: "PUT", url: Routes.api_users_service_benefit_path(':service_id', ':id')}
      destroy: {method: "DELETE", url: Routes.api_users_service_benefit_path(':service_id', ':id')}
    }
  return Benefit
]