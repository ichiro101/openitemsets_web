class CreateItemSets < ActiveRecord::Migration
  def change
    create_table :item_sets do |t|
      t.string :title, :null => false
      t.string :ingame_title, :null => false, :default => "Untitled Itemset"
      t.string :champion, :null => false, :default => "Ahri"
      t.string :role, :null => false

      # description in markdown form
      t.text :description

      # JSON list of map integer, as referred to by
      # https://developer.riotgames.com/docs/game-constants
      t.text :associated_maps, :default => "[]"

      # default this to 0, which is the SYSTEM user, we reserve
      # for item sets that are created by our own bots
      t.references :owner, :null => false, :default => 0

      t.boolean :visible_to_public, :null => false, :default => false

      t.timestamps
    end
  end
end
