do ->
  dashboardCtrl = ($scope, $location, Job, Service, Company) ->
    console.log "dashboard controller"
    $scope.company = gon.company
    Service.query (data, xhr)->
      $scope.services = data

    $scope.saveDomain = ->
      $scope.company = new Company($scope.company)
      $scope.company.$domain (data, xhr)->
        console.log data

  viewControllers = angular.module('app.dashboard.controller', [])
  viewControllers.controller 'dashboardCtrl', dashboardCtrl
  dashboardCtrl.$inject = [ '$scope', '$location', 'Job', 'Service', 'Company']

do ->
  dashboard = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/dashboard/show.html'
      controller: 'dashboardCtrl'
      link: ($scope, element, attrs) ->
        true
    }
  
  directives = angular.module('app.dashboard.directive', [])
  directives.directive 'dashboard', dashboard
  return