itemSetNamespace = angular.module('itemSet', [])

itemSetNamespace.controller("itemSetsController",  ($scope) ->
  $scope.allItems = gon.itemData

  $scope.selectedItems = _.filter($scope.allItems, (itemObject) ->
    itemObject.gold.purchasable
  )

)
