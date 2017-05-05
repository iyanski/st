do ->
  jobsCtrl = ($scope, $location, Job, ChatService, $routeParams, Order) ->
    console.log 'jobs controller'
    $scope.showUploader = false
    $scope.loadUpdates = false
    $scope.job_id = gon.job_id
    # $scope.categories = gon.categories
    $scope.services = gon.services
    
    $scope.initJobUpdates = ->
      jobsRef = ChatService.ref("updates/" + gon.company.id).limitToLast(1)
      jobsRef.on 'child_added', (snapshot)->
        if $scope.loadUpdates
          job = new Job(id: snapshot.val().job_id)
          $scope.find_job_by_id job.id, (item)->
            job.$get (data, xhr)->
              $scope.jobs[$scope.jobs.indexOf(item)] = job
              if $scope.job and $scope.job.id is job.id
                $scope.job = data
                $scope.refreshCurrentJob(job)
                console.log "You are looking at the current job"
              else
                console.log "A job has been updated"
              setTimeout ->
                $scope.$apply()
                $scope.initPresence()
              , 100
            , (res)->
              if res.data.error is "Job not found"
                pos = $scope.jobs.indexOf(item)
                $scope.jobs.splice(pos, 1)
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
      presenceRef = ChatService.ref(['presence',gon.company.id,'experts'].join("/"))
      presenceRef.on 'value', (snap)->
        angular.forEach snap.val(), (value, key)->
          $scope.showOnline(key)
      presenceRef.on 'child_removed', (snap)->
        $scope.showOffline(snap.key)
  
    $scope.initPresence()

    $scope.refreshCurrentJob = (job)->
      $scope.job = job
      $scope.messages = []
      $scope.loadImagePreviewer(job)
      if job and job.expert and job.customer
        $scope.initChat()
        setTimeout ->
          $scope.$apply()
          $scope.scrollToBottom()
        , 100

    $scope.selectJob = (job)->
      if $scope.notificationsRef
        $scope.notificationsRef.off 'child_added'
      $scope.show_mode = 1
      if $scope.job != job
        $scope.job = job
        $scope.showUploader = false
        $scope.messages = []
        console.log $scope.job
        $scope.form_action = ["/api/customers/jobs", job.id, "pay"].join("/")
        if job and job.expert and job.customer
          $scope.initChat()
          $scope.loadImagePreviewer(job)
          setTimeout ->
            $scope.$apply()
            $scope.scrollToBottom()
          , 100

    $scope.initChat = ->
      $scope.interactive = false
      if $scope.on and $scope.job
        $scope.msg = ""
        $scope.notificationsRef = ChatService.ref("messages/" + gon.company.id + "/" + $scope.job.id + "/" + [$scope.job.expert.id, $scope.job.customer.id].join("/"))
        $scope.notificationsRef.on 'child_added', (snapshot)->
          if !$scope.interactive
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && snapshot.val().sender_type is "Expert"
            $scope.pushMessage snapshot.val()
          setTimeout ->
            $scope.scrollToBottom()
            $scope.$apply()
          , 100

    $scope.initJob = ->
      if $routeParams.id
        $scope.find_job_by_id $routeParams.id, (job)->
          setTimeout ->
            $scope.selectJob(job)
          , 100

    $scope.initJob()

    if gon.job_id
      $scope.find_job_by_id $scope.job_id, (job)->
        setTimeout ->
          $scope.selectJob(job)
        , 100

    if $routeParams.id
      $scope.find_job_by_id $routeParams.id, (job)->
        setTimeout ->
          $scope.selectJob(job)
        , 100

    $scope.approveAndPay = (job)->
      $scope.processing = true
      order = new Order()
      order.job_id = $scope.job.id
      order.$paypal_url (data, xhr)->
        location.href = data.proceed_url

  viewControllers = angular.module('app.jobs.controller', [])
  viewControllers.controller 'jobsCtrl', jobsCtrl
  jobsCtrl.$inject = [ '$scope', '$location', 'Job', 'ChatService', '$routeParams', 'Order']

do ->
  jobs = ->
    {
      restrict: 'EA'
      templateUrl: 'customer/components/jobs/index.html'
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
    $scope.showUploader = false
    $scope.showDetails = true
    $scope.show_mode = 1
    
    dropzone = new Dropzone ".dropzone",
      url: Routes.api_customers_jobs_path()
      params:
        'authenticity_token': $('meta[name="csrf-token"]').attr('content')

    dropzone.on "complete", (file)->
      job = new Job($scope.job)
      console.log "complete", file
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
      dropzone.options.url = Routes.upload_api_customers_job_path($scope.job.id)
      $scope.showUploader = true
      $scope.showUploaderScreen()

    $scope.publishJob = ->
      $scope.newJob.status = 1
      $scope.newJob.$save (data, xhr)->
        $scope.jobs.unshift data
        pos = $scope.jobs.indexOf(data)
        $scope.selectedJob = $scope.jobs[pos]
        $scope.job = new Job(data)
        $scope.cancelCompose()

    $scope.draftJob = ->
      $scope.newJob.$save (data, xhr)->
        $scope.jobs.unshift data
        $scope.selectedJob = data
        $scope.cancelCompose()

    $scope.publish = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      $scope.jobs[pos].status = 1
      $scope.jobs[pos].created_at = new Date()
      job.$publish (data, xhr)->
        console.log data

    $scope.unpublish = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      $scope.jobs[pos].status = 0
      job.$unpublish (data, xhr)->
        console.log data

    $scope.declineEstimateFor = (job)->
      pos = $scope.jobs.indexOf(job)
      console.log $scope.jobs[pos]
      job = new Job(job)
      $scope.jobs[pos].status = 1
      $scope.jobs[pos].expert = null
      job.$decline (data, xhr)->
        console.log data

    $scope.cancelJob = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      if confirm("Cancelling will delete this job. Proceed?")
        $scope.jobs.splice(pos, 1)
        $scope.selectedJob = {}
        $scope.job = false
        job.$cancel (data, xhr)->
          console.log data

    $scope.complete = (job)->
      pos = $scope.jobs.indexOf(job)
      job = new Job(job)
      $scope.jobs[pos].status = 6
      $scope.jobs[pos].completed_at = moment()
      job.$complete (data, xhr)->
        console.log data

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
        sender_type: "Customer"
        content: msg
        sender : [$scope.customer.first_name, $scope.customer.last_name].join(" ")
        recipient_id: $scope.job.expert.id
        sender_id: $scope.job.customer.id
        created_at: moment()
      $scope.pushMessage(payload)
      $scope.interactive = true
      $scope.scrollToBottom()
      
      message = new Message(id: $scope.job.id)
      message.$chat content: msg, (data, xhr)->
        console.log "sent"

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
      templateUrl: 'customer/components/jobs/show.html'
      controller: 'jobCtrl'
      link: ($scope, element, attrs) ->
        true
    }

  
  directives = angular.module('app.job.directive', [])
  directives.directive 'job', job
  return