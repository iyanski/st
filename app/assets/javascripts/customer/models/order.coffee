# @app.factory "Order", [ "$resource", ($resource) ->
#   Order = $resource Routes.orders_path(),
#     { 
#       id: "@id"
#       job_id: "@job_id"
#     }
#     {
#       paypal_url: {method: "GET", url: Routes.express_orders_path(':job_id')}
#     }
#   return Order
# ]