do ->
  homePageCtrl = ($scope, $route, $rootScope, pageview, Job, ChatService) ->
    $scope.page_title = "Dashboard"
    $scope.online = []
    $scope.offline = []
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.selectJob = {}
    $scope.rate = gon.rate
    $scope.expert = gon.expert
    $scope.interactive = false
    $scope.jobs = gon.rabl
    $scope.show_mode = 1
    $scope.aid = gon.aid
    $scope.company = gon.company
    
    $scope.find_job_by_id = (job_id, callback)->
      job = null
      angular.forEach $scope.jobs, (result, key)->
        if parseInt(job_id) == parseInt(result.id)
          job = result
      callback(job)

    $scope.showOnline = (id)->
      angular.element(".customer-avatar[data-customer-id=" + id + "]").addClass("b-success").removeClass('b-grey')

    $scope.showOffline = (id)->
      angular.element(".customer-avatar[data-customer-id=" + id + "]").removeClass("b-success").addClass('b-grey')
    
    $scope.compose = ->
      $scope.newJob = new Job()
      $scope.composeJob = true

    $scope.cancelCompose = ->
      $scope.newJob = new Job()
      $scope.composeJob = false

    $scope.initMyPresence = ->
      presenceRef = ChatService.ref(['presence',gon.company.id,'experts',$scope.expert.id,'connections'].join("/"))
      connectedRef = ChatService.ref('.info/connected')
      connectedRef.on 'value', (snap)->
        if snap.val() is true
          con = presenceRef.push true
          con.onDisconnect().remove()

    $scope.initMyPresence()
    $scope.initNewJobRequest = ->
      # console.log angular.element(".user-avatar").length
      notificationsRef = ChatService.ref("jobs/" + gon.company.id).limitToLast(1)
      notificationsRef.on 'child_added', (snapshot)->
        if snapshot.val()
          $scope.find_job_by_id snapshot.key, (job)->
            console.log snapshot.val().content
            if snapshot.val().content == "cancelled the job"
              pos = $scope.jobs.indexOf(job)
              $scope.jobs.splice(pos, 1)
            else
              unless job
                job = new Job(id: snapshot.key)
                job.$get (data, xhr)->
                  if data.status > 0
                    $scope.jobs.unshift data
                    setTimeout ->
                      $scope.showOnline(data.customer.id)
                      toastr.success [snapshot.val().sender, snapshot.val().content].join(" ")
                    , 100
              else
                console.log "Job found"

    $scope.updatePresence = ->
      angular.forEach $scope.online, (item)->
        $scope.showOnline(item)
      angular.forEach $scope.offline, (item)->
        $scope.showOffline(item)

    $scope.initNewJobRequest()
    $scope.loadImagePreviewer = (job)->
      items = []
      if job.job_attachments
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

    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + gon.company.id).limitToLast(1)
      jobsRef.on 'child_added', (snapshot)->
        console.log snapshot.val()
    $scope.initJobUpdates()
    

  viewControllers = angular.module('app.home.page.controller', [])
  viewControllers.controller 'homePageCtrl', homePageCtrl
  homePageCtrl.$inject = [ '$scope', '$route', '$rootScope', 'pageview', 'Job', 'ChatService']