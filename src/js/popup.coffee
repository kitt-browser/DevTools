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


markParentNodes = ->
  $('.tree li:has(ul)')
    .addClass('parent_li')
    .find(' > span')
    .attr('title', 'Collapse this branch')


$ ->
  console.log('popup ready')

angular.module('SourceCodeTree', ['truncate', 'RecursionHelper'])

  .service 'MessengerService', ->
    @sendMessage = (msg, callback) ->
      chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
        console.log('sending message to', tabs[0], msg)
        chrome.tabs.sendMessage tabs[0].id, msg, callback

    return this


  .directive 'sourceNode', (RecursionHelper) ->
    restrict: 'A'
    scope:
      data: '='
    template: """
      <span ng-class="{node: true, parent: (data.nodes.length > 0), collapsed: !data.show}" ng-click="nodeClicked($event, data)">
        <i></i> 
        <span class="tag">{{data.tag}}</span>
        <span class="id">{{data.id}}</span>
        <span class="classes">{{data.classes}}</span>
      </span>
      <ul class="some" ng-show="data.show">       
        <li ng-repeat="data in data.nodes" class="parent_li"
          source-node data="data" ng-click="nodeClicked($event, data)"
          ng-controller="NodeCtrl"></div>
        </li>
      </ul>
    """
    compile: (element) ->
      RecursionHelper.compile element, (scope, element, attrs) ->


  .controller 'SourceTreeController', ($scope, $timeout, MessengerService) ->

    $scope.displayTree = null
    $scope.selectedNode = null

    MessengerService.sendMessage {cmd: 'getDOM'}, ({tree}) ->
      $scope.displayTree = tree
      $timeout ->
        markParentNodes()
      , 0
   
    
  .controller 'NodeCtrl', ($scope) ->

    $scope.nodeClicked = (e, node) ->
      node.show = not node.show
      $scope.selectedNode = node
      e.stopPropagation()

    $scope.showNode = (data) ->
