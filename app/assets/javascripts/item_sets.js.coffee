itemSetNamespace = angular.module('itemSet', ["checklist-model"])

defaultFilters = (itemData) ->
  purchasableItems = _.filter(itemData, (itemObject) ->
    itemObject.gold.purchasable
  )

  sortedItems = _.sortBy(purchasableItems, (itemObject) ->
    itemObject.gold.total
  )

tagFilter = (itemData, filter) ->
  _.filter(itemData, (itemObject) ->
    _.intersection(itemObject.tags, filter).length == filter.length
  )

orFilter = (itemData, orFilter) ->
  _.filter(itemData, (itemObject) ->
    result = false
    for filterObject in orFilter
      result = result or _.contains(itemObject.tags, filterObject)

      # early return if it's true
      if result
        return result
    result
  )

itemSetNamespace.controller("itemSetsController",  ($scope) ->
  $scope.textFilter = ""
  $scope.selectedCategoryFilter = "All"
  $scope.tagFilter = []
  $scope.orFilter = []


  $scope.clearFilters = () ->
    $scope.tagFilter = []
    $scope.orFilter = []
    $scope.performFilter()

  $scope.$watch('tagFilter', () ->
    $scope.performFilter()
    # once tag filter has changed, reset all the
    # categorical filters as well
    $scope.orFilter = []
  , true)

  # categorical filters are filtered
  # by an OR operation
  $scope.addCategoryFilter = (filter) ->
    if filter == "Tools"
      $scope.selectedCategoryFilter = "Tools"
      $scope.tagFilter = []
      $scope.orFilter = []
      $scope.orFilter.push('Consumable')
      $scope.orFilter.push('GoldPer')
      $scope.orFilter.push('Vision')
      $scope.orFilter.push('Trinket')
    else if filter == "Defense"
      $scope.selectedCategoryFilter = "Defense"
      $scope.tagFilter = []
      $scope.orFilter = []
      $scope.orFilter.push('Health')
      $scope.orFilter.push('Armor')
      $scope.orFilter.push('SpellBlock')
      $scope.orFilter.push('HealthRegen')
      $scope.orFilter.push('Tenacity')
    else if filter == "Attack"
      $scope.selectedCategoryFilter = "Attack"
      $scope.tagFilter = []
      $scope.orFilter = []
      $scope.orFilter.push('Damage')
      $scope.orFilter.push('CriticalStrike')
      $scope.orFilter.push('AttackSpeed')
      $scope.orFilter.push('Lifesteal')
    else if filter == "Magic"
      $scope.selectedCategoryFilter = "Magic"
      $scope.tagFilter = []
      $scope.orFilter = []
      $scope.orFilter.push('SpellDamage')
      $scope.orFilter.push('CooldownReduction')
      $scope.orFilter.push('SpellVamp')
      $scope.orFilter.push('Mana')
      $scope.orFilter.push('ManaRegen')

    else if filter == "Movement"
      $scope.selectedCategoryFilter = "Movement"
      $scope.tagFilter = []
      $scope.orFilter = []
      $scope.orFilter.push('Boots')
      $scope.orFilter.push('NonbootsMovement')


    $scope.performFilter()

  # perform the actual filtering
  $scope.performFilter = () ->
    itemData = gon.itemData

    if $scope.tagFilter.length > 0
      itemData = tagFilter(itemData, $scope.tagFilter)

    if $scope.orFilter.length > 0
      itemData = orFilter(itemData, $scope.orFilter)

    $scope.selectedItems = defaultFilters(itemData)
  

  $scope.performFilter()
)

itemSetNamespace.directive('tagCheckbox', () ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    console.log(attrs.tagCheckbox)

)
