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
  # itemData which was retrieved from redis
  $scope.itemData = gon.itemData

  # value of 1 means this item set is universal, value of
  # 0 means the item set is restricted
  $scope.mapOption = 1

  # if the item set is restricted, which map should
  # this be restricted to: see
  # https://developer.riotgames.com/docs/game-constants
  # for all the map constants
  $scope.selectedMap = 1

  # if a category checkbox is checked, this will be filled
  # with that value
  $scope.tagFilter = []


  # categorical filters will set these values, it's called
  # orFilter because we need to use the or operation on each
  # of the elements
  $scope.orFilter = []

  # where we store itemSetBlocks objects
  #
  # An ItemSetBlock object looks like this
  # {
  #   name: "Starting Items"  // title of the block
  #   items: [1001, ...]      // 
  # }
  $scope.itemSetBlocks = []

  # If All is selected, this is called. Clears all the
  # categorical and checkbox item shop filters
  $scope.clearFilters = () ->
    $scope.tagFilter = []
    $scope.orFilter = []
    $scope.performFilter()

  # We need to watch for changes to tagFilter model
  # so the item shop can filter accordingly
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
    itemData = $scope.itemData

    if $scope.tagFilter.length > 0
      itemData = tagFilter(itemData, $scope.tagFilter)

    if $scope.orFilter.length > 0
      itemData = orFilter(itemData, $scope.orFilter)

    $scope.selectedItems = defaultFilters(itemData)

  # initialize the item set blocks
  #
  # TODO: read the actual dataset from PostgresQL
  $scope.initItemSetBlocks = () ->
    $scope.itemSetBlocks = [{
      name: "Starting Items"
      items: [1001]
    }]



  $scope.performFilter()
  $scope.initItemSetBlocks()
)


itemSetNamespace.directive('itemDraggable', () ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.draggable(
      revert: "invalid"
      helper: "clone"
    )
)

itemSetNamespace.directive('itemDroppable', () ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.droppable(
      accept: ".item"
      drop: (event, ui) ->
        console.log("Item was Dropped")
        # $(this).append($(ui.draggable).clone())
    )
)
