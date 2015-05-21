class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.integer :event_id
      t.string :category

      t.timestamps null: false
    end
  end
end
