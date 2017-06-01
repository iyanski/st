do ->
  headerCtrl = ($scope, $location, ChatService) ->
    console.log 'header controller'
    $scope.avatar = gon.avatar
    $scope.notifications = []
    console.log "updates/" + $scope.company.id
    $scope.initNotifications = ->
      jobsRef = ChatService.ref("updates/" + $scope.company.id).limitToLast(5)
      jobsRef.on 'child_added', (snapshot)->
        console.log snapshot.val()
        data = 
          job_id: snapshot.val().job_id
          sender: snapshot.val().sender
          content: snapshot.val().content
          action: snapshot.val().action
          created_at: moment(snapshot.val().created_at).fromNow()
        angular.element("span.bubble").removeClass("hide")
        $scope.notifications.push data
      console.log jobsRef
    $scope.initNotifications()
    
    $scope.clearNotifications = ->
      angular.element("span.bubble").addClass("hide")
      true

    $scope.gotoJob = (id, e)->
      e.preventDefault()
      $location.path("/job/" + id)


  viewControllers = angular.module('app.header.controller', [])
  viewControllers.controller 'headerCtrl', headerCtrl
  headerCtrl.$inject = [ '$scope', '$location', 'ChatService']

do ->
  header = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/header/show.html'
      controller: 'headerCtrl'
    }

  directives = angular.module('app.header.directive', [])
  directives.directive 'header', header
  return