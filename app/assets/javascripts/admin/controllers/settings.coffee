do ->
  settingsPageCtrl = ($scope, $route, pageview) ->
    $scope.page_title = "Settings"

  viewControllers = angular.module('app.settings.page.controller', [])
  viewControllers.controller 'settingsPageCtrl', settingsPageCtrl
  settingsPageCtrl.$inject = [ '$scope', '$route', 'pageview']