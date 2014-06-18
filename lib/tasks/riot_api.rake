OIS_CONFIG = YAML.load_file(Rails.root.join('config', 'ois_config.yml'))


namespace :riot do

  desc "Sync all the static data we need from the Riot static data API"
  task :sync_all => [:items, :champions] do
    puts "all done!"
  end

  desc "Store items and champion data into a text files"
  task :store_preset do
    redis = Redis.new

    items_string = redis.get("items")
    champions_string = redis.get("champions")

    items_file = File.new(Rails.root.join('spec', 'items.json'), 'w')
    items_file.syswrite(items_string)

    champions_file = File.new(Rails.root.join('spec', 'champions.json'), 'w')
    champions_file.syswrite(champions_string)

    puts "files written in spec directory"
  end

  desc "Load txt file presets into the redis database"
  task :load_preset do
    items_file = File.new(Rails.root.join('spec', 'items.json'), 'r')
    champions_file = File.new(Rails.root.join('spec', 'champions.json'), 'r')

    redis = Redis.new
    redis.set("items", items_file.read)
    redis.set("champions", champions_file.read)

    puts "loaded preset"
  end

  desc "This task syncs the current item database from riot to our redis database"
  task :items do
    redis = Redis.new
    riot_api_key = OIS_CONFIG['riot_api']['key']

    items_client = Outrageous::StaticData::Item.new(:api_key => riot_api_key)
    items = items_client.all(:itemListData => 'all')

    puts "Writing Items, Ver #{items['version']}"
    redis.set("items", items.to_json)

    puts "Updated riot api item database"
  end

  desc "Prints the current items fetched from the riot api to the screen"
  task :print_items do
    require 'pp'
    redis = Redis.new
    items = JSON.parse(redis.get("items"))
    
    pp items
  end

  desc "This task syncs the current champion database from riot to our redis database"
  task :champions do
    redis = Redis.new
    riot_api_key = OIS_CONFIG['riot_api']['key']

    champions_client = Outrageous::StaticData::Champion.new(:api_key => riot_api_key)
    champions = champions_client.all(:champData => 'all')

    puts "Writing Champions, Ver #{champions['version']}"
    redis.set("champions", champions.to_json)

    puts "Updated riot api champion database"
  end

  desc "Prints the current champions data fetched from the riot api to the screen"
  task :print_champions do
    require 'pp'
    redis = Redis.new
    champions = JSON.parse(redis.get("champions"))
    
    pp champions
  end

end
