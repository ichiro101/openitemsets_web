class CreateBlockItems < ActiveRecord::Migration
  def change
    create_table :block_items do |t|
      t.references :item_set_block
      t.integer :item_id
      t.integer :rank

      t.timestamps
    end
  end
end
