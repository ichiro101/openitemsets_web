class CreateExceptionRecords < ActiveRecord::Migration
  def change
    create_table :exception_records do |t|
      t.string :class_name
      t.string :message
      t.text :backtrace

      t.timestamps
    end
  end
end
