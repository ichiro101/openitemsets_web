class CreateItemSets < ActiveRecord::Migration
  def change
    create_table :item_sets do |t|
      t.string :title, :default => ""
      t.string :ingame_title, :null => false, :default => "Untitled Itemset"
      t.string :champion, :null => false, :default => "Ahri"
      t.string :role, :null => false

      # description in markdown form
      t.text :description

      # default this to 0, which is the SYSTEM user, we reserve
      # for item sets that are created by our own bots
      t.references :user, :null => false, :default => 0

      t.boolean :visible_to_public, :null => false, :default => false

      # data
      t.integer :map_option
      t.integer :map
      t.text :item_set_json

      t.timestamps
    end
  end
end
