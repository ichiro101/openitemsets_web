class Item

  def self.version
    self.item_hash["version"]
  end

  def self.item_hash
    redis = Redis.new
    items = JSON.parse(redis.get("items"))

    items
  end
end
