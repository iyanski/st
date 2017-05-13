@app.factory "Transaction", [ "$resource", ($resource) ->
  Transaction = $resource Routes.api_experts_transactions_path(),
    { id: "@id" }
  return Transaction
]