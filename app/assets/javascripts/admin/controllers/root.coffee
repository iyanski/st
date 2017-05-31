do ->
  rootPageCtrl = ($scope, $route, pageview, ChatService) ->
    $scope.page_title = "Root"
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.jobs = gon.rabl
    $scope.user = gon.user
    $scope.aid = gon.aid
    $scope.company = gon.company
    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + gon.company.id).limitToLast(1)
      jobsRef.on 'child_added', (snapshot)->
        console.log snapshot.val()
    $scope.initJobUpdates()

  viewControllers = angular.module('app.root.controller', [])
  viewControllers.controller 'rootPageCtrl', rootPageCtrl
  rootPageCtrl.$inject = [ '$scope', '$route', 'pageview', 'ChatService']