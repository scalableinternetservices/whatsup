class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :city
      t.decimal :latitude,  :precision => 5, :scale => 5
      t.decimal :longitude, :precision => 5, :scale => 5
      t.timestamp :time
      t.text :description

      t.timestamps null: false
    end
  end
end
