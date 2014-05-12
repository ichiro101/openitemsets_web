class CreateItemSetBlocks < ActiveRecord::Migration
  def change
    create_table :item_set_blocks do |t|
      t.references :item_set
      t.string :block_title

      t.timestamps
    end
  end
end
