$ = require('jquery')
_ = require('lodash')

require('angular')
require('../vendor/angular-bootstrap/ui-bootstrap-tpls')
require('../vendor/angular-truncate/truncate')
require('../vendor/angular-recursion/angular-recursion')

require('./element.coffee')
common = require('./common.coffee')

# http://plnkr.co/edit/EvjX6O?p=preview

require('../css/tree.css')
require('../css/spinner.css')


log = common.log


# Set `parent` attribute for each node.
linkParents = (root) ->
  for node in root.nodes
    node.parent = root
    linkParents(node)


$ ->
  log('popup ready')

angular.module('SourceCodeTree', ['truncate', 'SourceCodeTree.node', 'ui.bootstrap'])

  .controller 'TabsCtrl', ->
    null


  .controller 'CssViewCtrl', ($scope) ->
    $scope.$watch 'data.selectedNode', (newNode, oldNode) ->
      return unless newNode?
      common.sendMessage { cmd: 'node:selected', guid: newNode.guid }, (obj) ->
        console.log obj
        $scope.css = obj.css


  .controller 'AppCtrl', ($scope) ->
    $scope.data = {
      selectedNode: null
    }


  .controller 'SourceTreeController', ($scope, $timeout) ->

    $scope.displayTree = null

    $scope.searchString = ''
    $scope.searchResults = []
    $scope.activeSearchResult = []

    common.sendMessage {cmd: 'dom:get'}, ({tree}) ->
      linkParents(tree)
      $scope.displayTree = tree
      $scope.$apply() unless $scope.$$phase

    # Returns all nodes whose `html` matches `searchRegexp`.
    searchNodes = (root, searchRegexp) ->
      res = []
      if root.html.match(new RegExp(searchRegexp, 'ig'))
        res = [root]
      for node in root.nodes
        res = res.concat(searchNodes(node, searchRegexp))
      return res

    # Get nodes on the path from `node` to root.
    getRootPath = (node) ->
      res = [node]
      while _.last(res).parent
        res.push _.last(res).parent
      return res

    # "Uncollapse" the nodes on the path from `node` to tree root.
    expandPathToNode = (node) ->
      path = getRootPath(node)
      # Expand all parent nodes.
      for node in path
        node.collapsed = false

    $scope.$watch 'activeSearchResult', (newNode, oldNode) ->
      log 'active search result changed'
      oldNode?.activeSearchResult = false
      if newNode?
        newNode.activeSearchResult = true
      $scope.data.selectedNode = $scope.activeSearchResult

    $scope.$watch 'selectedNode', (newNode, oldNode) ->
      log 'selected node changed', newNode
      oldNode?.selected = false
      if newNode?
        # This will cause the node to be scrolled into view (see the
        # `sourceNode` directive).
        newNode.selected = true
        expandPathToNode(newNode)

    # Returns the index of the active search result (so that we can
    # display "you're seeing the n-th search result out of m now").
    $scope.getSearchIndex = ->
      return 0 unless $scope.searchResults.length > 0
      $scope.searchResults.indexOf($scope.activeSearchResult)

    # Go to next search result.
    $scope.prevSearchResult = ->
      currentIndex = $scope.getSearchIndex()
      if currentIndex == 0
        currentIndex = $scope.searchResults.length
      index = (currentIndex - 1) % $scope.searchResults.length
      $scope.activeSearchResult = $scope.searchResults[index]

    # Go to previous search result.
    $scope.nextSearchResult = ->
      index = ($scope.getSearchIndex() + 1) % $scope.searchResults.length
      $scope.activeSearchResult = $scope.searchResults[index]

    # Observe changes to `searchString` so that we can react to new searches.
    # Note: We're debouncing so that there there's a delay between typing and
    # searching.
    $scope.$watch 'searchString', _.debounce (value) ->
      if value.length == 0
        # Search box wiped out. Reset.
        $scope.searchResults = null
        $scope.activeSearchResult = null
        return

      # Let us search!
      $scope.searchResults = searchNodes($scope.displayTree, value)
      node = $scope.searchResults[0]
      $scope.activeSearchResult = node

      # `$apply` because of debounce.
      $scope.$apply() unless $scope.$$phase
    , 1000

    $scope.$on 'node:selected', (event, node) ->
      $scope.data.selectedNode = node
