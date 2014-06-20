$ = require('../vendor/jquery/jquery')
_ = require('../vendor/underscore/underscore')

require('../css/content.css')

_jQuery = $.noConflict(true)


__i = 0

orig = console.log
console.log = ->
  args = Array::slice.call(arguments, 0)
  args.unshift(__i++)
  orig.apply(console, args)


makeNode = ($elem) ->
  $node = $elem.clone()
  $node.children().remove()

  return {
    nodes: []
    html: $('<div>').append($node).html()
    element: $elem
    name: $elem.prop('tagName')
    show: true
  }


(($) ->
  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    console.log "message received:", request.cmd
    switch request.cmd
      when 'getDOM'
        console.log '$html prepared'
        tree = parseDOM makeNode($('html'))
        console.log 'tree', JSON.stringify(tree, null, 2)

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


