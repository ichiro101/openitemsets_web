itemSetNamespace = angular.module('itemSet', [])

itemSetNamespace.controller("itemSetsController",  ($scope) ->
  $scope.allItems = gon.itemData

  purchasableItems = _.filter($scope.allItems, (itemObject) ->
    itemObject.gold.purchasable
  )

  sortedItems = _.sortBy(purchasableItems, (itemObject) ->
    itemObject.gold.total
  )

  $scope.selectedItems = sortedItems

)
