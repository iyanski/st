do ->
  jobsCtrl = ($scope, $location, Job, $routeParams, ChatService) ->
    console.log 'jobs controller'
    $scope.job_id = gon.job_id

    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + gon.company.id).limitToLast(1)
      jobsRef.on 'child_added', (snapshot)->
        if $scope.loadUpdates
          job = new Job(id: snapshot.val().job_id)
          $scope.find_job_by_id job.id, (item)->
            job.$get (data, xhr)->
              $scope.jobs[$scope.jobs.indexOf(item)] = data
              if $scope.job and $scope.job.id is job.id
                $scope.job = data
                $scope.refreshCurrentJob(job)
                console.log "You are looking at the current job"
              else
                console.log "A job has been updated"
              setTimeout ->
                $scope.initPresence()
                $scope.$apply()
              , 100
        $scope.loadUpdates = true

    $scope.initJobUpdates()
    
    $scope.selectJob = (job)->
      if $scope.notificationsRef
        $scope.notificationsRef.off 'child_added'
      if $scope.job != job
        $scope.job = job
        $scope.showUploader = false
        $scope.messages = []
        console.log $scope.job
        $scope.form_action = ["/api/experts/jobs", job.id, "pay"].join("/")
        if job and job.expert and job.user
          $scope.initChat()
          $scope.loadImagePreviewer(job)
          setTimeout ->
            $scope.$apply()
            $scope.scrollToBottom()
          , 100

    $scope.openImagePreview = (index, $event)->
      console.log index
      pswpElement = $(".pswp")[0]
      $event.preventDefault()
      options = 
        index: parseInt(index)
        escKey: true
        history: false
      gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, $scope.slides, options)
      gallery.init()

    $scope.initChat = ->
      console.log "init job"
      $scope.interactive = false
      if $scope.on and $scope.job
        $scope.msg = ""
        console.log $scope.job
        $scope.notificationsRef = ChatService.ref("messages/" + gon.company.id + "/" + $scope.job.id + "/" + [$scope.job.expert.id, $scope.job.user.id].join("/"))
        $scope.notificationsRef.on 'child_added', (snapshot)->
          console.log snapshot.val().system
          if !$scope.interactive
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && snapshot.val().sender_type is "Customer"
            $scope.pushMessage snapshot.val()
          console.log snapshot.val()
          setTimeout ->
            $scope.scrollToBottom()
            $scope.$apply()
          , 100

    if gon.job_id
      $scope.find_job_by_id $scope.job_id, (job)->
        console.log job
        $scope.selectJob(job)

    if $routeParams.id
      $scope.find_job_by_id $routeParams.id, (job)->
        $scope.selectJob(job)
    
  viewControllers = angular.module('app.jobs.controller', [])
  viewControllers.controller 'jobsCtrl', jobsCtrl
  jobsCtrl.$inject = [ '$scope', '$location', 'Job', '$routeParams', 'ChatService']

do ->
  jobs = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/jobs/index.html'
      controller: 'jobsCtrl'
      link: ($scope, element, attrs) ->
        # $('#wysiwyg5').wysihtml5()
    }

  directives = angular.module('app.jobs.directive', [])
  directives.directive 'jobs', jobs
  return


do ->
  jobCtrl = ($scope, $location, Job) ->
    console.log 'job controller'
    $scope.on = true
    $scope.messages = []

    $scope.pushMessage = (payload)->
      data = 
        sender_type: payload.sender_type
        content: payload.content
        recipient_id: payload.recipient_id
        sender_id: payload.sender_id
        sender: payload.sender
        created_at: moment(payload.created_at).fromNow()
      $scope.messages.push data

    $scope.scrollToBottom = ->
      offset = angular.element('.conversation').height
      target = angular.element('.conversation')
      target.animate
        scrollTop: offset
      , 100
      
    $scope.showDetails = (e)->
      e.preventDefault()
      $scope.show_mode = 1

    $scope.showConversations = (e)->
      e.preventDefault()
      $scope.show_mode = 2

    $scope.showFiles = (e)->
      e.preventDefault()
      $scope.show_mode = 3

  viewControllers = angular.module('app.job.controller', [])
  viewControllers.controller 'jobCtrl', jobCtrl
  jobCtrl.$inject = [ '$scope', '$location', 'Job']

do ->
  job = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/jobs/show.html'
      controller: 'jobCtrl'
      link: ($scope, element, attrs) ->
        true
    }
  
  directives = angular.module('app.job.directive', [])
  directives.directive 'job', job
  return