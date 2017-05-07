do ->
  stroreCtrl = ($scope, $location, Store) ->
    console.log "storefront controller"
    $scope.company = gon.company

    Store.get (data, xhr) ->
      $scope.store = data
      console.log $scope.store

  viewControllers = angular.module('app.store.controller', [])
  viewControllers.controller 'stroreCtrl', stroreCtrl
  stroreCtrl.$inject = [ '$scope', '$location', 'Store']

do ->
  storefront = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/store/index.html'
      controller: 'stroreCtrl'
      link: ($scope, element, attrs) ->
        true
    }
  
  directives = angular.module('app.store.directive', [])
  directives.directive 'storefront', storefront
  return