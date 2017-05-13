do ->
  transactionsCtrl = ($scope, $location, Transaction) ->
    console.log "transactions controller"
    $scope.company = gon.company
    
    $scope.init = ->
      Transaction.query (data, xhr)->
        $scope.transactions = data

    $scope.init()

  viewControllers = angular.module('app.transactions.controller', [])
  viewControllers.controller 'transactionsCtrl', transactionsCtrl
  transactionsCtrl.$inject = [ '$scope', '$location', 'Transaction']

do ->
  transactions = ->
    {
      restrict: 'EA'
      templateUrl: 'expert/components/transactions/index.html'
      controller: 'transactionsCtrl'
      link: ($scope, element, attrs) ->
        $scope.openTab = (tab)->
          angular.element(".tab-pane").removeClass('active')
          angular.element('#'+tab).toggleClass("active")
          true
    }
  
  directives = angular.module('app.transactions.directive', [])
  directives.directive 'transactions', transactions
  return