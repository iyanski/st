do ->
  settingsCtrl = ($scope, $location, Account, Settings) ->
    console.log 'settings controller'
    $scope.settings = new Settings(gon.settings)
    $scope.avatar = gon.avatar
    $scope.save = ->
      $scope.expert = new Account($scope.expert)
      if $scope.expert.current_password and $scope.expert.password isnt $scope.expert.password_confirmation
        toastr.warning "Your passwords does not match"
      else
        $scope.expert.$update (data, xhr)->
          toastr.success "Updated successfully"
        , (res)->
          toastr.warning res.data.error

    $scope.updateSetting = ->
      $scope.settings.$update (data, xhr)->
        console.log data
      , (res)->
        toastr.warning res.data.error

    $scope.initDropZone = ->
      dropzone = new Dropzone ".dropzone",
        url: Routes.upload_api_experts_account_path()
        method: 'post'
        params:
          'authenticity_token': $('meta[name="csrf-token"]').attr('content')
      dropzone.on "complete", (file)->
        dropzone.removeFile(file)
        response = JSON.parse(file.xhr.response)
        $scope.avatar = response.avatar
        $scope.save (data, xhr)->
          console.log data

  viewControllers = angular.module('app.settings.controller', [])
  viewControllers.controller 'settingsCtrl', settingsCtrl
  settingsCtrl.$inject = [ '$scope', '$location', 'Account', 'Settings']

do ->
  settings = ->
    {
      restrict: 'EA'
      templateUrl: 'expert/components/settings/show.html'
      controller: 'settingsCtrl'
      link: ($scope, element, attrs) ->
        $scope.initDropZone()
        $scope.openTab = (tab)->
          angular.element(".tab-pane").removeClass('active')
          angular.element('#'+tab).toggleClass("active")
          true
    }
  
  directives = angular.module('app.settings.directive', [])
  directives.directive 'settings', settings
  return