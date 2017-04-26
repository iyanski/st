@app.factory "Job", [ "$resource", ($resource) ->
  Job = $resource Routes.api_customers_jobs_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_customers_job_path(':id')}
      publish: {method: "PUT", url: Routes.publish_api_customers_job_path(':id')}
      unpublish: {method: "PUT", url: Routes.unpublish_api_customers_job_path(':id')}
      decline: {method: "PUT", url: Routes.decline_api_customers_job_path(':id')}
      cancel: {method: "PUT", url: Routes.cancel_api_customers_job_path(':id')}
      complete: {method: "PUT", url: Routes.complete_api_customers_job_path(':id')}
    }
  return Job
]