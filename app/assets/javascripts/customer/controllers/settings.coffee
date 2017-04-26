do ->
  settingsPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Settings"
    $scope.jobs = gon.rabl
    $scope.user = gon.user
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    
  viewControllers = angular.module('app.settings.page.controller', [])
  viewControllers.controller 'settingsPageCtrl', settingsPageCtrl
  settingsPageCtrl.$inject = [ '$scope', '$route', 'pageview']