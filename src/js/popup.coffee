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
      format: '='
    template: """
      <span ng-click="nodeClicked($event, data)">
        <i></i> 
        {{format}}
      </span>
      <ul class="some" ng-show="data.show">       
        <li ng-repeat="data in data.nodes" class="parent_li"
          source-node data="data" ng-click="nodeClicked($event, data)"
          format="showNode(data)" ng-controller="NodeCtrl"></div>
        </li>
      </ul>
    """
    compile: (element) ->
      RecursionHelper.compile element, (scope, element, attrs) ->
        console.log 'scope', _.values scope.data


  .controller 'SourceTreeController', ($scope, $timeout, MessengerService) ->

    $scope.displayTree = null
    $scope.selectedNode = null

    MessengerService.sendMessage {cmd: 'getDOM'}, ({tree}) ->
      $scope.displayTree = [tree]
      $timeout ->
        console.log('marking parent nodes')
        markParentNodes()
      , 0
   
    
  .controller 'NodeCtrl', ($scope) ->

    $scope.nodeClicked = (e, node) ->
      console.log 'clicked node', node.name
      $scope.selectedNode = node
      # TODO: This ought to be done via nganimate and model manipulation.
      children = $(e.target)
        .parent('li.parent_li')
        .find(' > ul > li')
      if children.is(":visible")
        console.log('hiding children')
        children.hide('fast')
        $(this).attr('title', 'Expand this branch')
          .find(' > i')
          .addClass('icon-plus-sign')
          .removeClass('icon-minus-sign')
      else
        console.log('showing children')
        children.show('fast')
        $(this).attr('title', 'Collapse this branch')
          .find(' > i')
          .addClass('icon-minus-sign')
          .removeClass('icon-plus-sign')
      e.stopPropagation()

    $scope.showNode = (data) ->
      name = data.name
      $elem = $(data.html)
      attrs = ''
      try
        _attrs = $elem.get(0).attributes
        attrs = ("#{_attrs.item(i).name}=#{_attrs.item(i).value}" for i in [0.._attrs.length - 1])
        attrs = attrs.join(' ')
        attrs = " " + attrs
      catch e
        attrs = ''
      return "#{name}#{attrs}"
