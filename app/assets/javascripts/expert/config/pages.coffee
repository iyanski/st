do ->
  pageview = ->
    {
      page:
        'page-home': 'expert/views/jobs.html'
        'page-settings': 'expert/views/settings.html'
    }

  pagepath = angular.module('app.pageview.factory', [])
  pagepath.factory 'pageview', pageview
  pageview.$inject = []
  return