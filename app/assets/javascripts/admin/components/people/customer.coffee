do ->
  customerCtrl = ($scope, $location, $routeParams, Customer, Job) ->
    console.log 'customer controller'

    Customer.get id: $routeParams.id, (data, xhr)->
      $scope.customer = data
    Job.query customer_id: $routeParams.id, (data, xhr)->
      $scope.customer_jobs = data
    Customer.sales id: $routeParams.id, (data, xhr)->
      $scope.sales = data.sales
    Customer.transactions id: $routeParams.id, (data, xhr)->
      $scope.transactions = data

    console.log $scope.jobs
    
  viewControllers = angular.module('app.customer.controller', [])
  viewControllers.controller 'customerCtrl', customerCtrl
  customerCtrl.$inject = [ '$scope', '$location', '$routeParams', 'Customer', 'Job']

do ->
  customer = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/people/customer_page.html'
      controller: 'customerCtrl'
    }

  directives = angular.module('app.customer.directive', [])
  directives.directive 'customer', customer
  return