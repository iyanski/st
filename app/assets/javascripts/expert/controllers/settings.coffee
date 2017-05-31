do ->
  settingsPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Settings"
    $scope.jobs = gon.rabl
    $scope.expert = gon.expert
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.aid = gon.aid
    $scope.company = gon.company
    
  viewControllers = angular.module('app.settings.page.controller', [])
  viewControllers.controller 'settingsPageCtrl', settingsPageCtrl
  settingsPageCtrl.$inject = [ '$scope', '$route', 'pageview']