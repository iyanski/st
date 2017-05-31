do ->
  rootPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Root"
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.jobs = gon.rabl
    $scope.user = gon.user
    $scope.aid = gon.aid
    $scope.company = gon.company
    $scope.store = gon.store
    
  viewControllers = angular.module('app.root.controller', [])
  viewControllers.controller 'rootPageCtrl', rootPageCtrl
  rootPageCtrl.$inject = [ '$scope', '$route', 'pageview']