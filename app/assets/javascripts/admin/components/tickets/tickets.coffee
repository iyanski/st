do ->
  ticketsCtrl = ($scope, $location, Ticket, Message, ChatService) ->
    console.log "tickets controller"
    $scope.company = gon.company
    
    $scope.init = ->
      Ticket.query (data, xhr)->
        $scope.tickets = data

    $scope.selectTicket = (item)->
      if $scope.ticket != item
        $scope.messages = []
        $scope.ticket = item
        $scope.interactive = false
        $scope.on = true
        $scope.initChat()
        setTimeout ->
          $scope.$apply()
        , 100

    $scope.initChat = ->
      if $scope.on and $scope.ticket
        $scope.msg = ""
        console.log "tickets/" + gon.company.id + "/" + $scope.ticket.id + "/" + $scope.ticket.conversation.code
        $scope.notificationsRef = ChatService.ref("tickets/" + gon.company.id + "/" + $scope.ticket.id + "/" + $scope.ticket.conversation.code)
        $scope.notificationsRef.on 'child_added', (snapshot)->
          console.log snapshot.val().sender_type, (snapshot.val().sender_type is "Expert" || snapshot.val().sender_type is "Customer")
          if !$scope.interactive
            console.log "non-interactive"
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && (snapshot.val().sender_type is "Expert" || snapshot.val().sender_type is "Customer")
            console.log "interactive"
            $scope.pushMessage snapshot.val()
          setTimeout ->
            $scope.$apply()
          , 100

    $scope.init()

    $scope.sendMessage = (e)->
      if $scope.on and $scope.ticket
        if e and (!e.shiftKey and e.keyCode is 13)
          $scope.sendChatMessage($(e.currentTarget).val())
          $(e.currentTarget).val('')
          true

    $scope.shiftSendMessage = ->
      $scope.sendChatMessage($scope.msg)

    $scope.sendChatMessage = (msg)->
      if $scope.ticket.customer
        data = 
          recipient_type: "Customer"
          recipient_id: $scope.ticket.customer.id
      else if $scope.ticket.expert
        data = 
          recipient_type: "Expert"
          recipient_id: $scope.ticket.expert.id

      payload = 
        sender_type: "User"
        recipient_type: data.recipient_type
        content: msg
        sender : [$scope.user.first_name, $scope.user.last_name].join(" ")
        recipient_id: data.recipient_id
        sender_id: $scope.user.id
        created_at: moment()
      $scope.pushMessage(payload)
      $scope.interactive = true
      
      message = new Message(id: $scope.ticket.id)
      message.$chat content: msg, recipient_type: data.recipient_type, recipient_id: data.recipient_id, (data, xhr)->
        true

    $scope.pushMessage = (payload)->
      data = 
        sender_type: payload.sender_type
        content: payload.content
        recipient_id: payload.recipient_id
        sender_id: payload.sender_id
        sender: payload.sender
        created_at: moment(payload.created_at).fromNow()
      $scope.messages.push data
      setTimeout ->
        $scope.scrollToBottom()
      , 100

    $scope.scrollToBottom = ->
      offset = angular.element('.conversation').height()
      splittarget = angular.element('.split-details')
      target = angular.element('.email-content-wrapper')
      splittarget.animate
        scrollTop: offset
      , 100
      target.animate
        scrollTop: offset
      , 100

  viewControllers = angular.module('app.tickets.controller', [])
  viewControllers.controller 'ticketsCtrl', ticketsCtrl
  ticketsCtrl.$inject = [ '$scope', '$location', 'Ticket', 'Message', 'ChatService']

do ->
  tickets = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/tickets/index.html'
      controller: 'ticketsCtrl'
    }
  
  directives = angular.module('app.tickets.directive', [])
  directives.directive 'tickets', tickets
  return


do ->
  ticketCtrl = ($scope, $location, Ticket) ->
    console.log "ticket controller"

  viewControllers = angular.module('app.ticket.controller', [])
  viewControllers.controller 'ticketCtrl', ticketCtrl
  ticketCtrl.$inject = [ '$scope', '$location', 'Ticket']

do ->
  ticket = ->
    {
      restrict: 'EA'
      templateUrl: 'admin/components/tickets/show.html'
      controller: 'ticketCtrl'
    }
  
  directives = angular.module('app.ticket.directive', [])
  directives.directive 'ticket', ticket
  return