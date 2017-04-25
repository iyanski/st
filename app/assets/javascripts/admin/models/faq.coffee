@app.factory "Faq", [ "$resource", ($resource) ->
  Faq = $resource Routes.api_users_service_faqs_path(':service_id'),
    { 
      id: "@id"
      service_id: "@service_id"
    }
    {
      get: {method: "GET", url: Routes.api_users_service_faq_path(':service_id', ':id')}
      update: {method: "PUT", url: Routes.api_users_service_faq_path(':service_id', ':id')}
    }
  return Faq
]