itemSetNamespace = angular.module('itemSet', ["checklist-model"])


$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['itemSet'])
  $('.item').tooltip(
    html: true
  )
)

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


buildJSON = (blockData, mapOption, selectedMap) ->
  console.log(blockData, mapOption, selectedMap)


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

  $scope.$watch('itemSetBlocks', () ->
    #TODO: implement this
    console.log('TODO: implement ajax uplink for itemSet updates')
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
    # 
    # tooltips
    
    # we need to get the information we want from the tool tip from the
    # item-id
    itemId = attrs.itemId
    itemId = parseInt(itemId)

    # set the tooltip
    elem.attr('title', setItemTooltip(scope.$parent.itemData, itemId))

    elem.draggable(
      revert: "invalid"
      helper: "clone"
    )
)

setItemTooltip = (itemData, itemId) ->
  tooltipString = "#{itemData[itemId].name}<br>
   #{itemData[itemId].description}"
  tooltipString

itemSetNamespace.directive('setItemDraggable', () ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    # 
    # tooltips
    
    # we need to get the information we want from the tool tip from the
    # item-id
    itemId = attrs.itemId
    itemId = parseInt(itemId)

    # set the tooltip
    elem.attr('title', setItemTooltip(scope.$parent.itemData, itemId))

    elem.draggable(
      revert: true
    )
)

itemSetNamespace.directive('itemDroppable', () ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.droppable(
      accept: ".item"
      drop: (event, ui) ->
        # only execute these if the item is actually from shop
        if ($(ui.draggable).attr("data-from-shop") != undefined)
          # get the index of the item set block where the item was dropped
          # to
          blockIndex = attrs.index

          # append the item to the end of the block item set
          itemId = $(ui.draggable).attr("data-item-id")
          itemId = parseInt(itemId)
          scope.$parent.itemSetBlocks[blockIndex].items.push(itemId)

          scope.$parent.$apply()
      out: (event, ui) ->
        # if the item is dragged out from the draggable item blocks
        # we must remove the item

        itemIndex = $(ui.draggable).attr("data-index")
        itemIndex = parseInt(itemIndex)

        blockIndex = $(ui.draggable).attr("data-block-index")
        blockIndex = parseInt(blockIndex)

        scope.$parent.itemSetBlocks[blockIndex].items.splice(itemIndex, 1)
        scope.$parent.$apply()
    )
)
