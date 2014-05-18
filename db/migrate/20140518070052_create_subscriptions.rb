class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :item_set
      t.references :user

      t.timestamps
    end
  end
end
