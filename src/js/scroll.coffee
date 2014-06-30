$ = require('jquery')
angular = require('angular')

angular.module('iScrollManager', [])

  .service 'iScrollManager', ($timeout) ->

    _self = this

    @createScrollbar = (name, el) ->
      console.log "test test", el
      _self[name] = new IScroll(el,
        click: true
        scrollX: true
      )

    @getInstance = (name) ->
      return _self[name]

    @refreshInstance = (name) ->
      $timeout (->
        _self[name].refresh()
      ), 10

    return this