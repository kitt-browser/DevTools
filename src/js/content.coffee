$ = require('jquery')
_ = require('lodash')

require('../css/content.css')

_jQuery = $.noConflict(true)

__i = 0

orig = console.log
console.log = ->
  args = Array::slice.call(arguments, 0)
  args.unshift(__i++)
  orig.apply(console, args)


guid = ->
  s4 = ->
    Math.floor((1 + Math.random()) * 0x10000)
      .toString(16).substring 1
  return s4() + s4() + "-" + s4() + "-" + s4() + "-" +
    s4() + "-" + s4()    + s4() + s4()


makeNode = ($elem) ->
  $node = $elem.clone()
  $node.children().remove()

  return {
    nodes: []
    html: $('<div>').append($node).html()
    element: $elem
    tag: $elem.prop('tagName')
    classes: $elem.attr('class')
    id: $elem.attr('id')
    collapsed: true
    selected: false
    activeSearchResult: false
    guid: guid()
  }

(($) ->
  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    console.log "message received:", request.cmd
    switch request.cmd
      when 'getDOM'
        console.log '$html prepared'
        tree = parseDOM makeNode($('html'))
        console.log 'parsing done'
        sendResponse({tree: tree})
      else
        window.alert('Unknow command', request.cmd)


  parseDOM = (root) ->
    #console.log 'processing', root.element.prop('tagName')
    root.element.children().each ->
      node = makeNode($(this))
      root.nodes.push parseDOM(node)

    delete root.element

    return root


  console.log 'content ready'

)(_jQuery)


