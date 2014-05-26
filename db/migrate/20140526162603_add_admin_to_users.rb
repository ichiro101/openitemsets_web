class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :integer, :null => false, :default => false
  end
end
