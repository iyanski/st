do ->
  homePageCtrl = ($scope, $route, pageview, $location) ->
    $scope.page_title = "Dashboard"
    $scope.activepage = $route.current.activepage
    $scope.activemenu = $route.current.activemenu
    $scope.selectJob = {}
    $scope.percentage = 25
    $scope.customer = gon.customer
    $scope.interactive = false
    $scope.jobs = gon.rabl
    $scope.show_mode = 1
    $scope.content = pageview.page[$route.current.activepage]
    # if $scope.jobs.length
    #   $scope.content = pageview.page[$route.current.activepage]
    # else
    #   $scope.content = pageview.page["page-dashboard"]

    # if $location.path == "/dashboard"
    #   $scope.content = pageview.page["page-dashboard"]

    $scope.find_job_by_id = (job_id, callback)->
      job = null
      angular.forEach $scope.jobs, (result, key)->
        console.log job_id, result.id
        if parseInt(job_id) == parseInt(result.id)
          job = result
      callback(job)


    $scope.showOnline = (id)->
      angular.element(".user-avatar[data-user-id=" + id + "]").addClass("b-success").removeClass('b-grey')
      console.log angular.element(".user-avatar").length
      console.log id

    $scope.showOffline = (id)->
      angular.element(".user-avatar[data-user-id=" + id + "]").removeClass("b-success").addClass('b-grey')

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
  homePageCtrl.$inject = [ '$scope', '$route', 'pageview', '$location']