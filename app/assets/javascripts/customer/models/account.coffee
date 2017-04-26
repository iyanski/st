@app.factory "Account", [ "$resource", ($resource) ->
  Account = $resource Routes.api_customers_account_path(),
    { id: "@id" }
    {
      update: {method: "PUT", url: Routes.api_customers_account_path()}
      upload: {method: "PUT", url: Routes.upload_api_customers_account_path()}
    }
  return Account
]