do ->
  sidebar = ->
    {
      restrict: 'EA'
      templateUrl: 'customer/components/sidebar/index.html'
      link: ($scope, element, attrs) ->
        $.Pages.init()
        $('.toggle-secondary-sidebar').click (e) ->
          e.stopPropagation()
          $('.secondary-sidebar').toggle()
          return
        $('.split-list-toggle').click ->
          $('.split-list').toggleClass 'slideLeft'
          return
        $('.secondary-sidebar').click (e) ->
          e.stopPropagation()
          return
        $(window).resize ->
          if $(window).width() <= 1024
            $('.secondary-sidebar').hide()
          else
            $('.split-list').length and $('.split-list').removeClass('slideLeft')
            $('.secondary-sidebar').show()
          return
        $('.list-view-wrapper').scrollbar()
    }

  directives = angular.module('app.sidebar.directive', [])
  directives.directive 'sidebar', sidebar
  return