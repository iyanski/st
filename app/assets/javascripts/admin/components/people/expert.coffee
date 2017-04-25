do ->
  expertCtrl = ($scope, $location, $routeParams, Expert) ->
    console.log 'expert controller'
    $scope.expert = new Expert()

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
    
  viewControllers = angular.module('app.expert.controller', [])
  viewControllers.controller 'expertCtrl', expertCtrl
  expertCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Expert']


do ->
  expert = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/people/expert_form.html'
      controller: 'expertCtrl'
    }

  directives = angular.module('app.expert.directive', [])
  directives.directive 'expert', expert
  return