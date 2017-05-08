do ->
  expertCtrl = ($scope, $location, $routeParams, Expert, Job) ->
    console.log 'expert controller'

    unless $routeParams.id
      $scope.expert = new Expert()
    else
      Expert.get id: $routeParams.id, (data, xhr)->
        $scope.expert = data
      Job.query expert_id: $routeParams.id, (data, xhr)->
        $scope.expert_jobs = data
      Expert.sales id: $routeParams.id, (data, xhr)->
        $scope.sales = data.sales
      Expert.transactions id: $routeParams.id, (data, xhr)->
        $scope.transactions = data

    $scope.saveExpertAccount = ->
      if $scope.expert.id
        $scope.expert.$update (data, xhr)->
          toastr.success "Expert account saved"
          $location.path("/people")
        , (res)->
          toastr.warning res.data.error
      else
        $scope.expert.$save (data, xhr)->
          toastr.success "Expert account created"
          $location.path("/people")
        , (res)->
          toastr.warning res.data.error

    console.log $scope.jobs
    
  viewControllers = angular.module('app.expert.controller', [])
  viewControllers.controller 'expertCtrl', expertCtrl
  expertCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Expert', 'Job']


do ->
  expert = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/people/expert_page.html'
      controller: 'expertCtrl'
    }

  directives = angular.module('app.expert.directive', [])
  directives.directive 'expert', expert
  return

do ->
  expertform = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/people/expertform.html'
      controller: 'expertCtrl'
    }

  directives = angular.module('app.expert.form.directive', [])
  directives.directive 'expertform', expertform
  return