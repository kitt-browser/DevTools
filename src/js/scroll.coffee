$ = require('jquery')
angular = require('angular')

angular.module('iScrollHelper', [])

  .directive 'scrollable', ->
    restrict: 'A'

    link: (element, attrs, scope) ->
      console.log "SKROLL INIT", element
      scroller = new IScroll element