do ->
  pageview = ->
    {
      page:
        'page-dashboard': 'admin/views/dashboard.html'
        'page-home': 'admin/views/jobs.html'
        'page-settings': 'admin/views/settings.html'
        'page-services': 'admin/views/services/index.html'
        'page-form-services': 'admin/views/services/form.html'
        'page-people': 'admin/views/people/index.html'
        'page-customer': 'admin/views/people/customer.html'
        'page-expert': 'admin/views/people/expert.html'
        'page-form-experts': 'admin/views/people/expert_form.html'
        'page-store': 'admin/views/store/index.html'
        'page-transactions': 'admin/views/transactions/index.html'
    }

  pagepath = angular.module('app.pageview.factory', [])
  pagepath.factory 'pageview', pageview
  pageview.$inject = []
  return