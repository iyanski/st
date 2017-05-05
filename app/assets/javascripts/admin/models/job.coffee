@app.factory "Job", [ "$resource", ($resource) ->
  Job = $resource Routes.api_customers_jobs_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_customers_job_path(':id'), isArray: false}
    }
  return Job
]