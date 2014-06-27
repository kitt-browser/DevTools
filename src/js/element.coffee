$ = require('jquery')
angular = require('angular')
common = require('./common.coffee')

angular.module('SourceCodeTree.node', ['RecursionHelper'])

  .directive 'sourceNode', (RecursionHelper) ->
    restrict: 'A'
    scope:
      data: '='
    template: """
      <span ng-class="{node: true, parent: (data.nodes.length > 0), collapsed: data.collapsed, selected: data.selected}" ng-click="nodeClicked($event, data)">
        <i></i> 
        <span class="tag">{{data.tag}}</span>
        <span class="id">{{data.id}}</span>
        <span class="classes">{{data.classes}}</span>
      </span>
      <ul class="some" ng-show="!data.collapsed">       
        <li ng-repeat="data in data.nodes"
          source-node data="data" ng-click="nodeClicked($event, data)"
          ng-controller="NodeCtrl"></div>
        </li>
      </ul>
    """
    compile: (element) ->
      RecursionHelper.compile element, (scope, element, attrs) ->
        scope.$watch 'data.selected', (activated) ->
          return unless activated
          $('html, body').animate {
            scrollTop: $(element).offset().top
          }, 500


  .controller 'NodeCtrl', ($scope) ->
    $scope.nodeClicked = (e, node) ->
      node.collapsed = not node.collapsed
      $scope.$emit 'node:selected', node
      e.stopPropagation()
