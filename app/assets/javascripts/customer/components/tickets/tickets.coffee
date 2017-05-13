do ->
  ticketsCtrl = ($scope, $location, Ticket) ->
    console.log "tickets controller"
    $scope.company = gon.company
    
    $scope.init = ->
      Ticket.query (data, xhr)->
        $scope.tickets = data

    $scope.selectTicket = (item)->
      $scope.ticket = item
      console.log item
      setTimeout ->
        $scope.$apply()
      , 100

    $scope.initChat = ->
      $scope.interactive = false
      if $scope.on and $scope.ticket
        $scope.msg = ""
        $scope.notificationsRef = ChatService.ref("tickets/" + gon.company.id + "/" + $scope.ticket.id + "/" + $scope.ticket.conversation.code)
        $scope.notificationsRef.on 'child_added', (snapshot)->
          console.log snapshot.val()
          if !$scope.interactive
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && snapshot.val().sender_type is ("Expert" || "Customer")
            $scope.pushMessage snapshot.val()
          setTimeout ->
            $scope.scrollToBottom()
            $scope.$apply()
          , 100

    $scope.init()
    $scope.initChat()

  viewControllers = angular.module('app.tickets.controller', [])
  viewControllers.controller 'ticketsCtrl', ticketsCtrl
  ticketsCtrl.$inject = [ '$scope', '$location', 'Ticket']

do ->
  tickets = ->
    {
      restrict: 'EA'
      templateUrl: 'customer/components/tickets/index.html'
      controller: 'ticketsCtrl'
    }
  
  directives = angular.module('app.tickets.directive', [])
  directives.directive 'tickets', tickets
  return


do ->
  ticketCtrl = ($scope, $location, Ticket) ->
    console.log "ticket controller"
    $scope.messages = []

  viewControllers = angular.module('app.ticket.controller', [])
  viewControllers.controller 'ticketCtrl', ticketCtrl
  ticketCtrl.$inject = [ '$scope', '$location', 'Ticket']

do ->
  ticket = ->
    {
      restrict: 'EA'
      templateUrl: 'customer/components/tickets/show.html'
      controller: 'ticketCtrl'
    }
  
  directives = angular.module('app.ticket.directive', [])
  directives.directive 'ticket', ticket
  return