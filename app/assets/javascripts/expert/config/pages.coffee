do ->
  pageview = ->
    {
      page:
        'page-home': 'expert/views/jobs.html'
        'page-settings': 'expert/views/settings.html'
        'page-transactions': 'expert/views/transactions.html'
        'page-tickets': 'expert/views/tickets.html'
    }

  pagepath = angular.module('app.pageview.factory', [])
  pagepath.factory 'pageview', pageview
  pageview.$inject = []
  return