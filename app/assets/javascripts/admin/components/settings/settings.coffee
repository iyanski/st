do ->
  settingsCtrl = ($scope, $location, Account) ->
    console.log 'settings controller'
    $scope.avatar = gon.avatar

    $scope.save = ->
      $scope.user = new Account($scope.user)
      if $scope.user.current_password and $scope.user.password isnt $scope.user.password_confirmation
        toastr.warning "Your passwords does not match"
      else
        $scope.user.$update (data, xhr)->
          toastr.success "Updated successfully"
        , (res)->
          toastr.warning res.data.error

    $scope.initDropZone = ->
      dropzone = new Dropzone ".dropzone",
        url: Routes.upload_api_users_account_path()
        method: 'post'
        params:
          'authenticity_token': $('meta[name="csrf-token"]').attr('content')
      dropzone.on "complete", (file)->
        dropzone.removeFile(file)
        response = JSON.parse(file.xhr.response)
        $scope.avatar = response.avatar.url
        $scope.save (data, xhr)->
          console.log data

    $scope.initDropZone()

  viewControllers = angular.module('app.settings.controller', [])
  viewControllers.controller 'settingsCtrl', settingsCtrl
  settingsCtrl.$inject = [ '$scope', '$location', 'Account']

do ->
  settings = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/settings/show.html'
      controller: 'settingsCtrl'
      link: ($scope, element, attrs) ->
        $scope.openTab = (tab)->
          angular.element(".tab-pane").removeClass('active')
          angular.element('#'+tab).toggleClass("active")
          true
    }
  
  directives = angular.module('app.settings.directive', [])
  directives.directive 'settings', settings
  return