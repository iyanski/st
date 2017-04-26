do ->
  homePageCtrl = ($scope, $route, $location, pageview, Job, ChatService) ->
    $scope.page_title = "Dashboard"
    $scope.online = []
    $scope.offline = []
    $scope.selectJob = {}
    $scope.rate = gon.rate
    $scope.customer = gon.customer
    $scope.jobs = gon.rabl
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.interactive = false
    $scope.show_mode = 1

    $scope.find_job_by_id = (job_id, callback)->
      job = null
      angular.forEach $scope.jobs, (result, key)->
        if parseInt(job_id) == parseInt(result.id)
          job = result
      callback(job)

    $scope.showOnline = (id)->
      angular.element(".expert-avatar[data-expert-id=" + id + "]").addClass("b-success").removeClass('b-grey')

    $scope.showOffline = (id)->
      angular.element(".expert-avatar[data-expert-id=" + id + "]").removeClass("b-success").addClass('b-grey')
    
    $scope.compose = ->
      $scope.newJob = new Job()
      $scope.composeJob = true

    $scope.cancelCompose = ->
      $scope.newJob = new Job()
      $scope.composeJob = false

    $scope.initMyPresence = ->
      presenceRef = ChatService.ref(['presence','users',$scope.customer.id,'connections'].join("/"))
      connectedRef = ChatService.ref('.info/connected')
      connectedRef.on 'value', (snap)->
        if snap.val() is true
          con = presenceRef.push true
          con.onDisconnect().remove()

    # $scope.updatePresence = ->
    #   angular.forEach $scope.online, (item)->
    #     $scope.showOnline(item)
    #   angular.forEach $scope.offline, (item)->
    #     $scope.showOffline(item)

    $scope.initMyPresence()
    $scope.loadImagePreviewer = (job)->
      items = []
      for item in job.job_attachments
        if item.file.url
          arr = item.file.url.match(/\-(\d+)x(\d+)\.(.*)/)
        if arr
          width = arr[1]
          height = arr[2]
          items.push
            src: item.file.url
            w: width
            h: height
      $scope.slides = items

    
  viewControllers = angular.module('app.home.page.controller', [])
  viewControllers.controller 'homePageCtrl', homePageCtrl
  homePageCtrl.$inject = [ '$scope', '$route', '$location', 'pageview', 'Job', 'ChatService']