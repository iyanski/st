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
      console.log(ChatService)
      if $scope.on and $scope.ticket
        $scope.msg = ""
        console.log "tickets/" + gon.company.id + "/" + $scope.ticket.id + "/" + $scope.ticket.conversation.code
        $scope.notificationsRef = ChatService.ref("tickets/" + gon.company.id + "/" + $scope.ticket.id + "/" + $scope.ticket.conversation.code)
        $scope.notificationsRef.on 'child_added', (snapshot)->
          console.log snapshot.val()
          if !$scope.interactive
            $scope.pushMessage snapshot.val()
          else if $scope.interactive && snapshot.val().sender_type is ("User")
            $scope.pushMessage snapshot.val()
          setTimeout ->
            $scope.scrollToBottom()
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
      $scope.interactive = true
      console.log $scope.expert
      $scope.msg = ""

      payload = 
        sender_type: "Expert"
        recipient_type: "User"
        content: msg
        sender : [$scope.expert.first_name, $scope.expert.last_name].join(" ")
        recipient_id: $scope.aid
        sender_id: $scope.expert.id
        created_at: moment()
      $scope.pushMessage(payload)
      $scope.interactive = true
      $scope.scrollToBottom()
      
      message = new Message(id: $scope.ticket.id)
      message.$chat content: msg, recipient_type: "User", recipient_id: $scope.aid, (data, xhr)->
        console.log "sent"
        

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
      templateUrl: 'expert/components/tickets/index.html'
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
      templateUrl: 'expert/components/tickets/show.html'
      controller: 'ticketCtrl'
    }
  
  directives = angular.module('app.ticket.directive', [])
  directives.directive 'ticket', ticket
  return