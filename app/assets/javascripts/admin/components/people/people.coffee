do ->
  peopleCtrl = ($scope, $location, $routeParams, Expert, Customer) ->
    console.log 'people controller'
    $scope.openTab = (tab)->
      angular.element(".tab-pane").removeClass('active')
      angular.element('#'+tab).toggleClass("active")
      true

    $scope.init = ->
      Expert.query (data, xhr)->
        $scope.experts = data
      Customer.query (data, xhr)->
        $scope.customers = data

    $scope.init()
    
  viewControllers = angular.module('app.people.controller', [])
  viewControllers.controller 'peopleCtrl', peopleCtrl
  peopleCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Expert', 'Customer']


do ->
  people = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/people/index.html'
      controller: 'peopleCtrl'
    }

  directives = angular.module('app.people.directive', [])
  directives.directive 'people', people
  return