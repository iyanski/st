@app.factory "Settings", [ "$resource", ($resource) ->
  Settings = $resource Routes.api_experts_settings_path(),
    { id: "@id" }
    {
      update: {method: "PATCH", url: Routes.api_experts_settings_path()}
    }
  return Settings
]