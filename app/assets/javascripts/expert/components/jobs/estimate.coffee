do ->
  estimateCtrl = ($scope, $location, Job) ->
    $scope.estimate = 
      hours: 1
      etc: 1
      starts_at: moment().format("L")
    console.log $scope.job
  viewControllers = angular.module('app.estimate.controller', [])
  viewControllers.controller 'estimateCtrl', estimateCtrl
  estimateCtrl.$inject = [ '$scope', '$location', 'Job']

do ->
  estimatemodal = ->
    {
      restrict: 'EA'
      templateUrl: 'expert/components/jobs/estimate_modal.html'
      controller: 'estimateCtrl'
      link: ($scope, element, attrs) ->
        if $scope.job and $scope.job.starts_at
          $('#start-date').datepicker
            todayHighlight: true
            startDate: moment($scope.job.starts_at).format("L")
        else
          $('#start-date').datepicker
            todayHighlight: true
            startDate: moment().format("L")
    }
  directives = angular.module('app.estimate.directive', [])
  directives.directive 'estimatemodal', estimatemodal
  return