class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email
      t.string :email_confirmation_token
      t.boolean :email_confirmed, :null => false, :default => false
      t.string :hashed_password, :null => false

      t.timestamps
    end
  end
end
