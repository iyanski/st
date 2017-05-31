'use strict';
@app = angular.module("SmallTaskers", [
  'ngResource'
  'ngRoute'
  'angularMoment'
  'templates'
  'ng-rails-csrf'
  'ngSanitize'
  
  'app.root.controller'
  'app.home.page.controller'
  'app.settings.page.controller'

  'app.jobs.controller'
  'app.jobs.directive'

  'app.job.controller'
  'app.job.directive'

  'app.estimate.controller'
  'app.estimate.directive'

  'app.settings.controller'
  'app.settings.directive'

  'app.transactions.controller'
  'app.transactions.directive'

  'app.tickets.controller'
  'app.tickets.directive'
  'app.ticket.controller'
  'app.ticket.directive'

  'app.sidebar.directive'
  'app.pageview.factory'
  
]).filter 'nl2br', ->
  (text) ->
    if text then text.replace(/\n/g, "<br/>") else ''
.filter 'str2link', ->
  (text) ->
    if text
      urlRegex = /(((file|ftp|https?:\/\/)|(www\.))[^\s]+)/g
      return text.replace(urlRegex, (url, b, c) ->
        url = if c == 'www.' then 'http://' + url else url
        '<a href="' + url + '" target="_blank">' + url + '</a>'
      )
    return
.filter 'stripTags', ->
  return (text)->
    if text 
      return String(text).replace(/<[^>]+>/gm, '')
    else 
      return ''
.filter 'job_status', ->
  (text) ->
    if text == 0 then "Draft"
    else if text == 1 then "Unclaimed"
    else if text == 2 then "Claimed"
    else if text == 3 then "Awaiting Payment"
    else if text == 4 then "In Progress"
    else if text == 5 then "Submitted for Approval"
    else if text == 6 then "Completed"
    else if text == 7 then "Closed"
      
.directive 'convertToNumber', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
      ngModel.$parsers.push (val) ->
        parseInt val, 10
      ngModel.$formatters.push (val) ->
        '' + val
      return

  }
.filter 'ticket_status', ->
  (text) ->
    if text == 0 then "New"
    else if text == 1 then "Ongoing"
    else if text == 2 then "Resolved"