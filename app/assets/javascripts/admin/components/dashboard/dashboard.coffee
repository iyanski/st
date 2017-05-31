do ->
  dashboardCtrl = ($scope, $location, Job, Service, Company) ->
    console.log "dashboard controller"

    Service.query (data, xhr)->
      $scope.services = data

    $scope.hasStoreFront = ->
      hasTitle = $scope.store.title
      hasDescription = $scope.store.description
      hasCover = $scope.store.cover.url
      hasTitle && hasDescription && hasCover

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