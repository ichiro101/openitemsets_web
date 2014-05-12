OIS_CONFIG = YAML.load_file(Rails.root.join('config', 'ois_config.yml'))


namespace :riot do

  desc "Sync all the static data we need from the Riot static data API"
  task :sync_all => [:items, :champions] do
    puts "all done!"
  end

  desc "This task syncs the current item database from riot to our redis database"
  task :items do
    redis = Redis.new
    riot_api_key = OIS_CONFIG['riot_api']['key']

    items_client = Outrageous::StaticData::Item.new(:api_key => riot_api_key)
    items = items_client.all(:itemListData => 'all')
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
