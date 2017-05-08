'use strict';
@app = angular.module("SmallTaskers", [
  'ngResource'
  'ngRoute'
  'angularMoment'
  'templates'
  'ng-rails-csrf'
  'ngSanitize'
  'ngPhotoswipe'

  'app.root.controller'
  
  'app.home.page.controller'
  'app.settings.page.controller'

  'app.dashboard.controller'
  'app.dashboard.directive'

  'app.jobs.controller'
  'app.jobs.directive'

  'app.job.controller'
  'app.job.directive'

  'app.people.controller'
  'app.people.directive'

  'app.store.controller'
  'app.store.directive'

  'app.services.controller'
  'app.services.directive'

  'app.service.controller'
  'app.service.directive'

  'app.expert.controller'
  'app.expert.directive'
  'app.expert.form.directive'

  'app.customer.controller'
  'app.customer.directive'

  'app.transactions.controller'
  'app.transactions.directive'

  'app.sidebar.directive'

  'app.pageview.factory'
]).filter 'nl2br', ->
  (text) ->
    if text then text.replace(/\n/g, " <br/>") else ''
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

.filter 'service_type', ->
  (text) ->
    if text == 0 then "Hourly"
    else if text == 1 then "Monthly"