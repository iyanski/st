@app.factory "Job", [ "$resource", ($resource) ->
  Job = $resource Routes.api_experts_jobs_path(),
    { id: "@id" }
    {
      get: {method: "GET", url: Routes.api_experts_job_path(':id'), isArray: false}
      claim: {method: "PUT", url: Routes.claim_api_experts_job_path(':id')}
      unclaim: {method: "PUT", url: Routes.unclaim_api_experts_job_path(':id')}
      estimate: {method: "PUT", url: Routes.estimate_api_experts_job_path(':id')}
      submit: {method: "PUT", url: Routes.submit_api_experts_job_path(':id')}
      cancel: {method: "PUT", url: Routes.cancel_api_experts_job_path(':id')}
    }
  return Job
]