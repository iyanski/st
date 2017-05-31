do ->
  rootPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Root"
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.jobs = gon.rabl
    $scope.user = gon.user
    $scope.aid = gon.aid

  viewControllers = angular.module('app.root.controller', [])
  viewControllers.controller 'rootPageCtrl', rootPageCtrl
  rootPageCtrl.$inject = [ '$scope', '$route', 'pageview']