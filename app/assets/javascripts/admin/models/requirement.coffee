@app.factory "Requirement", [ "$resource", ($resource) ->
  Requirement = $resource Routes.api_users_service_requirements_path(':service_id'),
    { 
      id: "@id"
      service_id: "@service_id"
    }
    {
      get: {method: "GET", url: Routes.api_users_service_requirement_path(':service_id', ':id')}
      update: {method: "PUT", url: Routes.api_users_service_requirement_path(':service_id', ':id')}
      destroy: {method: "DELETE", url: Routes.api_users_service_requirement_path(':service_id', ':id')}
    }
  return Requirement
]