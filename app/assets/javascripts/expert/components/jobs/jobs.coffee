do ->
  jobsCtrl = ($scope, $location, Job, ChatService, $routeParams) ->
    console.log 'jobs controller'
    $scope.showUploader = false
    $scope.loadUpdates = false
    $scope.job_id = gon.job_id

    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates").limitToLast(1)
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

    $scope.initPresence = ->
      presenceRef = ChatService.ref(['presence','users'].join("/"))
      presenceRef.on 'value', (snap)->
        angular.forEach snap.val(), (value, key)->
          $scope.showOnline(key)
      presenceRef.on 'child_removed', (snap)->
        $scope.showOffline(snap.key)
        angular.element(".user-avatar[data-user-id=" + snap.key + "]").removeClass("b-success").addClass('b-grey')
    
    $scope.initPresence()

    $scope.refreshCurrentJob = (job)->
      $scope.selectJob(job)

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

    # $scope.selectJob = (job)->
    #   $scope.job = job
    #   $scope.messages = []
    #   if job and job.expert and job.user
    #     $scope.initChat()
    #     $scope.loadImagePreviewer(job)
    #     setTimeout ->
    #       $scope.scrollToBottom()
    #       $scope.$apply()
    #     , 100
    #     # notificationsRef = ChatService.ref("messages/" + job.id + [job.expert.id, job.user.id].join("-"))
    #     # notificationsRef.on 'child_added', (snapshot)->
    #     #   stimulant = snapshot.val().action

    $scope.initChat = ->
      console.log "init job"
      $scope.interactive = false
      if $scope.on and $scope.job
        $scope.msg = ""
        console.log $scope.job
        $scope.notificationsRef = ChatService.ref("messages/" + $scope.job.id + "/" + [$scope.job.expert.id, $scope.job.user.id].join("/"))
        $scope.notificationsRef.on 'child_added', (snapshot)->
          console.log snapshot.val().system
          if !$scope.interactive
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && snapshot.val().sender_type is "User"
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
  jobsCtrl.$inject = [ '$scope', '$location', 'Job', 'ChatService', '$routeParams']

do ->
  jobs = ->
    {
      restrict: 'EA'
      templateUrl: 'expert/components/jobs/index.html'
      controller: 'jobsCtrl'
      link: ($scope, element, attrs) ->
        # $('#wysiwyg5').wysihtml5()
    }

  
  directives = angular.module('app.jobs.directive', [])
  directives.directive 'jobs', jobs
  return


do ->
  jobCtrl = ($scope, $location, Job, ChatService, Message) ->
    console.log 'job controller'
    $scope.on = true
    $scope.messages = []

    dropzone = new Dropzone ".dropzone",
      url: Routes.api_experts_jobs_path()
      params:
        'authenticity_token': $('meta[name="csrf-token"]').attr('content')

    dropzone.on "complete", (file)->
      job = new Job($scope.job)
      job.$get (data, xhr)->
        $scope.jobs[$scope.jobs.indexOf(job)] = job
        if $scope.job and $scope.job.id is job.id
          $scope.job = data
          $scope.refreshCurrentJob(job)
          console.log "You are looking at the current job"
        else
          console.log "A job has been updated"
        $scope.showUploader = false
        setTimeout ->
          $scope.$apply()
          $scope.initPresence()
        , 100
        dropzone.removeAllFiles()

    $scope.attachFile = ->
      dropzone.options.url = Routes.upload_api_experts_job_path($scope.job.id)
      $scope.showUploader = true
      $scope.showUploaderScreen()

    $scope.claim = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      $scope.jobs[pos].status = 2
      $scope.jobs[pos].claimed_at = moment()
      job.$claim (data, xhr)->
        console.log data
        $scope.jobs[pos] = job
        $scope.job = $scope.jobs[pos]
        setTimeout ->
          $scope.initChat()
        , 100

    $scope.sendMessage = (e)->
      if $scope.on and $scope.job
        if e and (!e.shiftKey and e.keyCode is 13)
          $scope.sendChatMessage($(e.currentTarget).val()) 

    $scope.shiftSendMessage = ->
      $scope.sendChatMessage($scope.msg)

    $scope.sendChatMessage = (msg)->
      $scope.interactive = true
      $scope.msg = ""
      payload = 
        sender_type: "Expert"
        content: msg
        sender : [$scope.expert.first_name, $scope.expert.last_name].join(" ")
        recipient_id: $scope.job.expert.id
        sender_id: $scope.job.expert.id
        created_at: moment()
      $scope.pushMessage(payload)
      $scope.interactive = true
      $scope.scrollToBottom()
      
      message = new Message(id: $scope.job.id)
      message.$chat content: msg, (data, xhr)->
        console.log payload

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
      target = angular.element('.chat')
      target.animate
        scrollTop: target[0].scrollHeight
      , 100

    $scope.makeEstimate = ->
      $scope.showModalEstimate = true
      $scope.estimate = 
        hours: 1
        etc: 1
        starts_at: moment().format("L")
      $("#estimate-modal").modal("show")
      true

    $scope.editEstimate = ->
      $scope.showModalEstimate = true
      $scope.estimate = 
        hours: $scope.job.estimate
        etc: $scope.job.etc
        starts_at: moment($scope.job.starts_at).format("L")
      setTimeout ->
        $scope.$apply()
      , 100
      console.log $scope.estimate
      $("#estimate-modal").modal("show")
      true

    $scope.sendEstimate = ->
      job = new Job($scope.job)
      job.estimate = $scope.estimate.hours
      job.etc = $scope.estimate.etc
      job.starts_at = $scope.estimate.starts_at
      job.status = 3
      job.estimated_at = moment()
      job.$estimate (data, xhr)->
        console.log data
        setTimeout ->
          $("#estimate-modal").modal("hide")
        , 100

    $scope.submit = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      $scope.jobs[pos].status = 5
      $scope.jobs[pos].submitted_at = moment()
      job.$submit (data, xhr)->
        console.log data

    $scope.showUploaderScreen = ->
      $scope.show_mode = 3

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
  jobCtrl.$inject = [ '$scope', '$location', 'Job', 'ChatService', 'Message']

do ->
  job = ->
    {
      restrict: 'EA'
      templateUrl: 'expert/components/jobs/show.html'
      controller: 'jobCtrl'
      link: ($scope, element, attrs) ->
        true
    }

  
  directives = angular.module('app.job.directive', [])
  directives.directive 'job', job
  return