@app.factory "Company", [ "$resource", ($resource) ->
  Company = $resource Routes.api_users_companies_path(),
    { 
      id: "@id"
    }
    {
      domain: {method: "POST", url: Routes.domain_api_users_companies_path()}
    }
  return Company
]