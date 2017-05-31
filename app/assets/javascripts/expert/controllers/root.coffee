do ->
  rootPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Root"
    $scope.jobs = gon.rabl
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activemenu = $route.current.activemenu
    $scope.activemenu = $route.current.activemenu
    $scope.aid = gon.aid
    $scope.expert = gon.expert
    $scope.company = gon.company

  viewControllers = angular.module('app.root.controller', [])
  viewControllers.controller 'rootPageCtrl', rootPageCtrl
  rootPageCtrl.$inject = [ '$scope', '$route', 'pageview']