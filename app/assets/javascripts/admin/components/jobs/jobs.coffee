do ->
  jobsCtrl = ($scope, $location, Job, $routeParams, ChatService) ->
    console.log 'jobs controller'
    $scope.job_id = gon.job_id
    $scope.activities = []

    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + $scope.company.id).limitToLast(1)
      jobsRef.off 'child_added'
      jobsRef.on 'child_added', (snapshot)->
        if $scope.loadUpdates
          job = new Job(id: snapshot.val().job_id)
          $scope.find_job_by_id job.id, (item)->
            job.$get (data, xhr)->
              $scope.jobs[$scope.jobs.indexOf(item)] = data
              if $scope.job and $scope.job.id is job.id
                $scope.job = data
                # $scope.refreshCurrentJob(job)
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
      if !job
        $location.path("/jobs")
      else
        if $scope.job != job
          $scope.job = job
          $scope.showUploader = false
          $scope.messages = []
          $scope.initChat()
          $scope.form_action = ["/api/experts/jobs", job.id, "pay"].join("/")
          $scope.loadImagePreviewer(job)
          setTimeout ->
            $scope.$apply()
          , 100

    $scope.openImagePreview = (index, $event)->
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
      # console.log $scope.company
      if $scope.on and $scope.job
        $scope.msg = ""
        $scope.notificationsRef = ChatService.ref("messages/" + $scope.company.id + "/" + $scope.job.id + "/" + $scope.job.conversation.code)
        $scope.notificationsRef.off 'value'
        $scope.notificationsRef.on 'value', (snapshot)->
          convos = snapshot.val()
          if convos
            Object.keys(convos).forEach (item)->
              if convos.hasOwnProperty(item)
                if $scope.activities.indexOf(item) < 0
                  $scope.pushMessage convos[item]
                  $scope.activities.push item
          setTimeout ->
            $scope.$apply()
          , 100

    if gon.job_id
      $scope.find_job_by_id $scope.job_id, (job)->
        $scope.selectJob(job)

    if $routeParams.id
      Job.get id: $routeParams.id, (job, xhr)->
        if job
          $scope.selectJob(job)
        else
          toastr.warning "Job not found"
          $location.path "/jobs"
      , (res)->
        toastr.warning "Job not found"
        $location.path("/jobs")

    $scope.initPresence = ->
      presenceRef = ChatService.ref(['presence',$scope.company.id,'customers'].join("/"))
      presenceRef.off 'value'
      presenceRef.on 'value', (snap)->
        angular.forEach snap.val(), (value, key)->
          $scope.showOnline('customer', key)
      presenceRef.on 'child_removed', (snap)->
        $scope.showOffline('customer', snap.key)

      presenceRef = ChatService.ref(['presence',$scope.company.id,'experts'].join("/"))
      presenceRef.off 'value'
      presenceRef.on 'value', (snap)->
        angular.forEach snap.val(), (value, key)->
          $scope.showOnline('expert', key)
      presenceRef.on 'child_removed', (snap)->
        $scope.showOffline('expert', snap.key)
    $scope.initPresence()
    
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
      setTimeout ->
        $scope.scrollToBottom()
      , 100

    $scope.scrollToBottom = ->
      offset = angular.element('.conversation').height()
      splittarget = angular.element('.split-details')
      target = angular.element('.email-content-wrapper')
      splittarget.animate
        scrollTop: offset
      , 100
      target.animate
        scrollTop: offset
      , 100
      
    $scope.showDetails = (e)->
      e.preventDefault()
      $scope.show_mode = 1

    $scope.showConversations = (e)->
      e.preventDefault()
      $scope.show_mode = 2
      setTimeout ->
        $scope.scrollToBottom()
      , 50

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