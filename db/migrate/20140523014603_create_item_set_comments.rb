class CreateItemSetComments < ActiveRecord::Migration
  def change
    create_table :item_set_comments do |t|
      t.references :item_set, :null => false
      t.references :user, :null => false
      t.text :comment

      t.timestamps
    end
  end
end
