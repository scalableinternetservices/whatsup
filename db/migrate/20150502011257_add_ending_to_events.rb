class AddEndingToEvents < ActiveRecord::Migration
  def change
    add_column :events, :end_time, :datetime
		rename_column :events, :time, :start_time
		rename_column :events, :city, :location
  end
end
