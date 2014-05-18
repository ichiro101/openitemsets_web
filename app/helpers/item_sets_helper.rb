module ItemSetsHelper

  def item_img_for(item_id)
    image_tag("http://static.openitemsets.com/img/item/#{item_id}.png")
  end

  def item_gold(item_id)
    Item.item_hash["data"][item_id.to_s]["gold"]["total"]
  end

  def item_description(item_id)
    Item.item_hash["data"][item_id.to_s]["description"]
  end

end
