do ->
  rootPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Settings"
    $scope.jobs = gon.rabl
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.aid = gon.aid
    $scope.customer = gon.customer
    
  viewControllers = angular.module('app.root.controller', [])
  viewControllers.controller 'rootPageCtrl', rootPageCtrl
  rootPageCtrl.$inject = [ '$scope', '$route', 'pageview']