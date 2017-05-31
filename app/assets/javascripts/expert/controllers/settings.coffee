do ->
  settingsPageCtrl = ($scope, $route, pageview, ChatService) ->
    $scope.page_title = "Settings"
    $scope.jobs = gon.rabl
    $scope.expert = gon.expert
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.aid = gon.aid
    $scope.company = gon.company
    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + gon.company.id).limitToLast(1)
      jobsRef.on 'child_added', (snapshot)->
        console.log snapshot.val()
    $scope.initJobUpdates()
    
  viewControllers = angular.module('app.settings.page.controller', [])
  viewControllers.controller 'settingsPageCtrl', settingsPageCtrl
  settingsPageCtrl.$inject = [ '$scope', '$route', 'pageview', 'ChatService']