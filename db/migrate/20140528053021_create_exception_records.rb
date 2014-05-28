class CreateExceptionRecords < ActiveRecord::Migration
  def change
    create_table :exception_records do |t|
      t.text :class_name
      t.text :message
      t.text :backtrace

      t.timestamps
    end
  end
end
