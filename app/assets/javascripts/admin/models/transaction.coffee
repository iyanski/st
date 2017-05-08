@app.factory "Transaction", [ "$resource", ($resource) ->
  Transaction = $resource Routes.api_users_transactions_path()
  return Transaction
]