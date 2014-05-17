itemSetNamespace = angular.module('itemSet', ["checklist-model"])


$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['itemSet'])
)

# the default item shop filter, filters out all the items
# we cannot buy
defaultFilters = (itemData) ->
  purchasableItems = _.filter(itemData, (itemObject) ->
    itemObject.gold.purchasable
  )

  sortedItems = _.sortBy(purchasableItems, (itemObject) ->
    itemObject.gold.total
  )

# perform checkbox filtering
tagFilter = (itemData, filter) ->
  _.filter(itemData, (itemObject) ->
    _.intersection(itemObject.tags, filter).length == filter.length
  )

# perform categorical filtering
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

# strip all the items that require a certain champion, of which
# we are not...
checkRequiredChampion = (itemData) ->
  _.filter(itemData, (itemObject) ->
    if itemObject.requiredChampion != undefined
      # if we are not the requiredChampion attribute
      # this needs to return false
      gon.champion == itemObject.requiredChampion
    else
      # if there is no requiredChampion attribute, then
      # return true
      true
  )



buildJSON = (blockData, mapOption, selectedMap) ->
  exportObj = {}
  if mapOption == '0'
    # if map option is zero, then we have to have a selected map
    exportObj.associatedMaps = [selectedMap]
  else
    # if map option is set to 1, it means we have to clear associatedMaps array
    exportObj.associatedMaps = []

  exportObj.blocks = []
  for itemBlock in blockData
    blockObj =
      type: itemBlock.name
      items: []

    for item in itemBlock.items
      itemObject =
        count: 1
        id: item
      blockObj.items.push(itemObject)

    exportObj.blocks.push(blockObj)

  exportObj.map = 'any'
  exportObj

itemSetNamespace.controller("itemSetsController",  ($scope, $http) ->
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

  # returns the javascript object which represents the
  $scope.convertToExportFormat = () ->


  # We need to watch for changes to tagFilter model
  # so the item shop can filter accordingly
  $scope.$watch('tagFilter', () ->
    $scope.performFilter()
    # once tag filter has changed, reset all the
    # categorical filters as well
    $scope.orFilter = []
  , true)

  # sends an ajax request to the rails web server to
  # sync the current item set to the ones stored
  # on the rails server
  $scope.updateItemSet = () ->
    obj = buildJSON($scope.itemSetBlocks, $scope.mapOption, $scope.selectedMap)
    console.log(obj)
    data =
      authenticity_token: gon.authToken
      json: angular.toJson(obj)

    # TODO: error handling
    $http.put("/item_sets/#{gon.itemSetId}/update_json", data)


  $scope.$watch('itemSetBlocks', () ->
    $scope.updateItemSet()
  , true)

  $scope.$watch('mapOption', () ->
    $scope.updateItemSet()
  , true)

  $scope.$watch('selectedMap', () ->
    # only update if mapOption is set to 0, which means
    # selectedMap value is actually useful
    if $scope.mapOption == "0"
      $scope.updateItemSet()
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

    itemData = checkRequiredChampion(itemData)

    if $scope.tagFilter.length > 0
      itemData = tagFilter(itemData, $scope.tagFilter)

    if $scope.orFilter.length > 0
      itemData = orFilter(itemData, $scope.orFilter)

    $scope.selectedItems = defaultFilters(itemData)

  # initialize the item set blocks
  $scope.initItemSetBlocks = () ->
    if gon.setData?
      if gon.setData.associatedMaps.length == 0
        # if there is no associated maps, then we can use
        # this item set for ANY maps, hence the mapOption is
        # set to 1
        $scope.mapOption = '1'
      else
        # if there is any associated maps, it means
        # we can only choose a specific map, and not any map
        # hence mapOption is set to 0
        $scope.mapOption = '0'
        $scope.selectedMap = gon.setData.associatedMaps[0]

      for itemBlock in gon.setData.blocks
        block =
          name: itemBlock.type
          items: []
        for item in itemBlock.items
          block.items.push(parseInt(item.id))
        $scope.itemSetBlocks.push(block)
    else
      $scope.itemSetBlocks = [
        name: "Starting Items"
        items: [1001]
      ]


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

    # once the attribute is known, now activate the tooltip
    $(elem).tooltip(
      html: true
    )

    elem.draggable(
      revert: "invalid"
      helper: "clone"
    )
)

setItemTooltip = (itemData, itemId) ->
  tooltipString = "#{itemData[itemId].name}<br><br>
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

    # once the attribute is known, now activate the tooltip
    $(elem).tooltip(
      html: true
    )

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
