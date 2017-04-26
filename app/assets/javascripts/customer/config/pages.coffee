do ->
  pageview = ->
    {
      page:
        'page-home': 'customer/views/jobs.html'
        'page-settings': 'customer/views/settings.html'
    }

  pagepath = angular.module('app.pageview.factory', [])
  pagepath.factory 'pageview', pageview
  pageview.$inject = []
  return