class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :user
      t.integer :event

      t.timestamps null: false
    end
  end
end
