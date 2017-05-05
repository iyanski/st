do ->
  homePageCtrl = ($scope, $route, $rootScope, pageview, Job, ChatService) ->
    $scope.page_title = "Dashboard"
    $scope.content = pageview.page[$route.current.activepage]
    $scope.activepage = $route.current.activepage
    $scope.selectJob = {}
    $scope.rate = gon.rate
    $scope.percentage = 25
    $scope.expert = gon.expert
    $scope.interactive = false
    $scope.jobs = gon.rabl
    $scope.show_mode = 1
    
    $scope.find_job_by_id = (job_id, callback)->
      job = null
      angular.forEach $scope.jobs, (result, key)->
        if parseInt(job_id) == parseInt(result.id)
          job = result
      callback(job)

    $scope.showOnline = (id)->
      angular.element(".user-avatar[data-user-id=" + id + "]").addClass("b-success").removeClass('b-grey')
      # console.log angular.element(".user-avatar").length
      # console.log id
      true

    $scope.showOffline = (id)->
      angular.element(".user-avatar[data-user-id=" + id + "]").removeClass("b-success").addClass('b-grey')
    
    $scope.compose = ->
      $scope.newJob = new Job()
      $scope.composeJob = true

    $scope.cancelCompose = ->
      $scope.newJob = new Job()
      $scope.composeJob = false

    $scope.initMyPresence = ->
      presenceRef = ChatService.ref(['presence','experts',$scope.expert.id,'connections'].join("/"))
      connectedRef = ChatService.ref('.info/connected')
      connectedRef.on 'value', (snap)->
        if snap.val() is true
          con = presenceRef.push true
          con.onDisconnect().remove()

    $scope.initNewJobRequest = ->
      # console.log angular.element(".user-avatar").length
      notificationsRef = ChatService.ref("jobs").limitToLast(1)
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

    $scope.initNewJobRequest()
    $scope.initMyPresence()
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
    

  viewControllers = angular.module('app.home.page.controller', [])
  viewControllers.controller 'homePageCtrl', homePageCtrl
  homePageCtrl.$inject = [ '$scope', '$route', '$rootScope', 'pageview', 'Job', 'ChatService']