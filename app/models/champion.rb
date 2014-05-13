class Champion
  def self.version
    self.champion_hash["version"]
  end

  def self.names
    self.champion_hash["data"].map { |k, v| k }
  end

  def self.champion_hash
    redis = Redis.new
    result = JSON.parse(redis.get("champions"))

    result
  end
end
