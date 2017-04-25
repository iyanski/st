do ->
  servicesCtrl = ($scope, $location, $routeParams, Service) ->
    console.log 'services controller'

    $scope.init = ->
      Service.query (data, xhr)->
        $scope.services = data

    $scope.init()

    $scope.goto = (id)->
      $location.path("/service/" + id)
    
  viewControllers = angular.module('app.services.controller', [])
  viewControllers.controller 'servicesCtrl', servicesCtrl
  servicesCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Service']


do ->
  services = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/services/index.html'
      controller: 'servicesCtrl'
      link: ($scope, element, attrs) ->
        # $('#wysiwyg5').wysihtml5()
    }

  directives = angular.module('app.services.directive', [])
  directives.directive 'services', services
  return


do ->
  serviceCtrl = ($scope, $location, $routeParams, Service, Benefit, Requirement, Faq) ->
    console.log 'service controller'
    $scope.benefits = []
    $scope.requirements = []
    $scope.faqs = []

    $scope.benefit = new Benefit()
    $scope.requirement = new Requirement()
    $scope.faq = new Faq()

    if $routeParams.id
      Service.get id: $routeParams.id, (data, xhr)->
        $scope.service = data
        $scope.initDropZone()
      Benefit.query service_id: $routeParams.id, (data, xhr)->
        $scope.benefits = data
      Requirement.query service_id: $routeParams.id, (data, xhr)->
        $scope.requirements = data
      Faq.query service_id: $routeParams.id, (data, xhr)->
        $scope.faqs = data
    else
      $scope.service = new Service(price: 50.00, service_type: 0, experts_rate: 75, platform_fee: 12)

    $scope.addBenefit = ->
      $scope.benefit.service_id = $scope.service.id
      $scope.benefit.$save (data, xhr)->
        $scope.benefits.push new Benefit(data)
        $scope.benefit = new Benefit()

    $scope.addRequirement = ->
      $scope.requirement.service_id = $scope.service.id
      $scope.requirement.$save (data, xhr)->
        $scope.requirements.push new Requirement(data)
        $scope.requirement = new Requirement()
    
    $scope.addFaq = ->
      $scope.faq.service_id = $scope.service.id
      $scope.faq.$save (data, xhr)->
        $scope.faqs.push new Faq(data)
        $scope.faq = new Faq()

    $scope.save = ->
      if $scope.service.id
        $scope.service.$update (data, xhr)->
          toastr.success [$scope.service.title, "is successfully saved"].join(" ")
        , (res)->
          toastr.warning res.data.error
      else
        $scope.service.$save (data, xhr)->
          toastr.success [$scope.service.title, "is successfully saved"].join(" ")
          $location.path("/service/" + data.id)
          setTimeout ->
            offset = angular.element("#benefits").offset().top - 70
            angular.element('.inner-content').animate({scrollTop: offset}, 500)
          , 100
        , (res)->
          toastr.warning res.data.error

    $scope.initDropZone = ->
      dropzone = new Dropzone ".dropzone",
        url: Routes.upload_api_users_service_path($scope.service.id)
        method: 'put'
        params:
          'authenticity_token': $('meta[name="csrf-token"]').attr('content')
      dropzone.on "complete", (file)->
        dropzone.removeFile(file)
        $scope.save()
    
  viewControllers = angular.module('app.service.controller', [])
  viewControllers.controller 'serviceCtrl', serviceCtrl
  serviceCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Service', 'Benefit', 'Requirement', 'Faq']


do ->
  service = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/services/form.html'
      controller: 'serviceCtrl'
      link: ($scope, element, attrs) ->
        # $('#wysiwyg5').wysihtml5()
    }

  directives = angular.module('app.service.directive', [])
  directives.directive 'service', service
  return