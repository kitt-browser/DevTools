#http://plnkr.co/edit/EvjX6O?p=preview

console.log('popup')


$ ->
  console.log('popup ready')
  $('.tree li:has(ul)')
    .addClass('parent_li')
    .find(' > span')
    .attr('title', 'Collapse this branch')

  $('.tree li.parent_li > span')
    .on 'click', (e) ->
      children = $(this)
        .parent('li.parent_li')
        .find(' > ul > li')
      if children.is(":visible")
          children.hide('fast')
          $(this).attr('title', 'Expand this branch')
            .find(' > i')
            .addClass('icon-plus-sign')
            .removeClass('icon-minus-sign')
      else
        children.show('fast')
        $(this).attr('title', 'Collapse this branch')
          .find(' > i')
          .addClass('icon-minus-sign')
          .removeClass('icon-plus-sign')
      e.stopPropagation()


angular.module('SourceCodeTree', ['ui.bootstrap'])

  .controller 'DialogDemoCtrl', ($scope, $dialog, $http) ->
    buildEmptyTree()
    console.log('empty tree built')

    $scope.selectedNode = ""
   
    $scope.showNode = (data) ->
      console.log(data)
      return data.name

    $scope.isClient = (selectedNode) ->
      return false unless selectedNode?
      if selectedNode.device_name != undefined
        return true
      return false

 buildEmptyTree = ->
   $scope.displayTree =
     [{
       "name": "Root",
       "type_name": "Node",
       "show": true,
       "nodes": [{
           "name": "Loose",
           "group_name": "Node-1",
           "show": true,
           "nodes": [{
               "name": "Node-1-1",
               "device_name": "Node-1-1",
               "show": true,
               "nodes": []
           }, {
               "name": "Node-1-2",
               "device_name": "Node-1-2",
               "show": true,
               "nodes": []
           }, {
               "name": "Node-1-3",
               "device_name": "Node-1-3",
               "show": true,
               "nodes": []
           }]
       }, {
           "name": "God",
           "group_name": "Node-2",
           "show": true,
           "nodes": [{
               "name": "Vadar",
               "device_name": "Node-2-1",
               "show": true,
               "nodes": []
           }]
       }, {
           "name": "Borg",
           "group_name": "Node-3",
           "show": true,
           "nodes": []
       }, {
           "name": "Fess",
           "group_name": "Node-4",
           "show": true,
           "nodes": []
       }]
  }]
