class Champion
  attr_accessor :id
  attr_accessor :name
  attr_accessor :title

  def self.all
    champ_data = self.champion_hash["data"]

    # this should not happen at all
    if champ_data.blank?
      raise StandardError, "rake riot:sync_all has not been ran or something went wrong with redis database"
    end

    champion_array = Array.new
    champ_data.each do |key, record|
      champ = Champion.new

      champ.id = record["id"]
      champ.name = record["name"]
      champ.title = record["title"]
      champion_array << champ
    end

    champion_array.sort_by! { |m| m.id.downcase }
  end

  def self.version
    self.champion_hash["version"]
  end

  def self.names
    champions_array = self.champion_hash["data"].map { |k, v| k }.to_a
    champions_array.sort_by! { |m| m.downcase }
  end

  def self.champion_hash
    redis = Redis.new
    result = JSON.parse(redis.get("champions"))

    result
  end

  def display_name
    "#{self.name}, #{self.title}"
  end

  def champion_image_url
    "http://static.openitemsets.com/img/champion/#{self.champion}.png"
  end
end
