$ = require('jquery')
_ = require('lodash')
inspector = require('./cssInspect.coffee')

require('../css/content.css')
common = require('./common.coffee')

log = common.log


_jQuery = $.noConflict(true)


makeNode = ($elem) ->
  # Silly dance to get the HTML of *just this* element (i.e., not of the
  # subtree). 
  $node = $elem.clone()
  $node.children().remove()

  return {
    nodes: []
    html: $('<div>').append($node).html()
    element: $elem

    tag: $elem.prop('tagName')
    classes: $elem.attr('class')
    id: $elem.attr('id')

    # Flags used by the popup view.
    collapsed: true
    selected: false
    activeSearchResult: false

    # `guid` is here so that we can map the tree nodes in popup to the elements
    # in the real DOM. We can't send reference to the elements directly because
    # jQuery element is not stringifiable.
    guid: common.guid()
  }


# Make the tree strignifiable so that we can send it to the popup via
# chrome messaging).
makeStringifiable = (root) ->
  for node in root.nodes
    makeStringifiable(node)
  delete root.element


# Make it easier to search for a node by its GUID.
createGuidMapping = (root, obj) ->
  for node in root.nodes
    createGuidMapping(node, obj)
  obj[root.guid] = root.element


# Returns a tree of nodes (which is easier to process in the popup script).
# Note: this needs to be made stringifiable before sending to popup.
parseDOM = (root) ->
  root.element.children().each ->
    node = makeNode($(this))
    root.nodes.push parseDOM(node)
  return root


(($) ->
  tree = null
  elemDict = {}

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    log "message received:", request.cmd
    switch request.cmd
      when 'dom:get'
        tree = parseDOM makeNode($('html'))
        # Create a guid => $element mapping.
        createGuidMapping(tree, elemDict)
        makeStringifiable(tree)
        sendResponse({tree: tree})

      when 'node:selected'
        log elemDict[request.guid]
        # Print any found CSS rules for this element.
        css = inspector.css(elemDict[request.guid])
        log 'css', css
        sendResponse({css: css})

      else
        window.alert('Unknow command', request.cmd)

  log 'content ready'

)(_jQuery)


