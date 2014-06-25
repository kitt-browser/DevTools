$ = require('../vendor/jquery/jquery')
_ = require('underscore')

require('angular')
require('../vendor/angular-truncate/truncate')
require('../vendor/angular-recursion/angular-recursion')

require('./element.coffee')

# http://plnkr.co/edit/EvjX6O?p=preview

require('../css/tree.css')
require('../css/spinner.css')

__i = 0

orig = console.log
console.log = ->
  args = Array::slice.call(arguments, 0)
  args.unshift(__i++)
  orig.apply(console, args)


linkParents = (root) ->
  for node in root.nodes
    node.parent = root
    linkParents(node)


$ ->
  console.log('popup ready')

angular.module('SourceCodeTree', ['truncate', 'SourceCodeTree.node'])

  .service 'MessengerService', ->
    @sendMessage = (msg, callback) ->
      chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
        console.log('sending message to', tabs[0], msg)
        chrome.tabs.sendMessage tabs[0].id, msg, callback

    return this


  .controller 'SourceTreeController', ($scope, $timeout, MessengerService) ->

    $scope.displayTree = null
    $scope.selectedNode = null

    $scope.searchString = ''
    $scope.searchResults = []
    $scope.activeSearchResult = []

    MessengerService.sendMessage {cmd: 'getDOM'}, ({tree}) ->
      #console.log 'tree', JSON.stringify(tree, null, 2)
      linkParents(tree)
      $scope.displayTree = tree
      $scope.$apply() unless $scope.$$phase

    searchNodes = (root, searchString) ->
      res = []
      if root.html.match(new RegExp(searchString, 'ig'))
        res = [root]
      for node in root.nodes
        res = res.concat(searchNodes(node, searchString))
      return res

    getRootPath = (node) ->
      res = [node]
      while _.last(res).parent
        res.push _.last(res).parent
      return res

    jumpToNode = (node) ->
      path = getRootPath(node)
      console.log 'path to root', _.pluck path, 'tag'
      # Expand all parent nodes.
      _.each path, (node) -> node.collapsed = false
      $timeout ->

    $scope.$watch 'activeSearchResult', (newNode, oldNode) ->
      oldNode?.activeSearchResult = false
      if newNode?
        newNode.activeSearchResult = true
      $scope.selectedNode = $scope.activeSearchResult

    $scope.$watch 'selectedNode', (newNode, oldNode) ->
      console.log 'selectedNode', newNode?.tag
      oldNode?.selected = false
      if newNode?
        newNode.selected = true
        jumpToNode(newNode)

    $scope.getSearchIndex = ->
      return 0 unless $scope.searchResults.length > 0
      console.log 'getSearchIndex'
      $scope.searchResults.indexOf($scope.activeSearchResult)

    $scope.prevSearchResult = ->
      index = ($scope.getSearchIndex() - 1) % $scope.searchResults.length
      $scope.activeSearchResult = $scope.searchResults[index]

    $scope.nextSearchResult = ->
      index = ($scope.getSearchIndex() + 1) % $scope.searchResults.length
      $scope.activeSearchResult = $scope.searchResults[index]

    $scope.$watch 'searchString', _.debounce (value) ->
      if value.length == 0
        $scope.searchResults = null
        $scope.activeSearchResult = null
        return

      $scope.searchResults = searchNodes($scope.displayTree, value)
      node = $scope.searchResults[0]
      $scope.activeSearchResult = node
      $scope.$apply() unless $scope.$$phase
    , 1000

    $scope.$on 'node:selected', (event, node) ->
      $scope.selectedNode = node
