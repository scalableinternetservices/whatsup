class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :message
      t.integer :event_id
      t.boolean :hasSeen

      t.timestamps null: false
    end
  end
end
