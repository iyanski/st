@app.factory "Customer", [ "$resource", ($resource) ->
  Customer = $resource Routes.api_users_customers_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_users_customer_path(':id')}
      sales: {method: "GET", url: Routes.sales_api_users_customer_path(':id')}
      transactions: {method: "GET", url: Routes.transactions_api_users_customer_path(':id'), isArray: true}
    }
  return Customer
]