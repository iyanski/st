do ->
  stroreCtrl = ($scope, $location, Store) ->
    console.log "storefront controller"
    $scope.company = gon.company
    $scope.store = new Store(gon.store)

    $scope.initDropZone = ->
      dropzone = new Dropzone ".dropzone",
        url: Routes.upload_cover_api_users_store_path()
        method: 'post'
        params:
          'authenticity_token': $('meta[name="csrf-token"]').attr('content')
      dropzone.on "complete", (file)->
        dropzone.removeFile(file)
        response = JSON.parse(file.xhr.response)
        $scope.store.cover = response.cover
        setTimeout ->
          $scope.$apply()
        , 100

    $scope.initDropZone()

    $scope.saveTitle = ->
      $scope.store.$update (data, xhr)->
        $scope.store = data
        toastr.success "Saved Title"
      , (res)->
        toastr.warning res.data.error

    $scope.saveDescription = ->
      $scope.store.$update (data, xhr)->
        $scope.store = data
        toastr.success "Saved Description"
      , (res)->
        toastr.warning res.data.error

    $scope.saveTagline = ->
      $scope.store.$update (data, xhr)->
        $scope.store = data
        toastr.success "Saved Tagline"
      , (res)->
        toastr.warning res.data.error

    $scope.saveSocial = ->
      $scope.store.$update (data, xhr)->
        $scope.store = data
        toastr.success "Saved social account(s)"
      , (res)->
        toastr.warning res.data.error

  viewControllers = angular.module('app.store.controller', [])
  viewControllers.controller 'stroreCtrl', stroreCtrl
  stroreCtrl.$inject = [ '$scope', '$location', 'Store']

do ->
  storefront = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/store/index.html'
      controller: 'stroreCtrl'
      link: ($scope, element, attrs) ->
        true
    }
  
  directives = angular.module('app.store.directive', [])
  directives.directive 'storefront', storefront
  return