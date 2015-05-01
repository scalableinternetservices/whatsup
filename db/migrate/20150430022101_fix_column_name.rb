class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :attendances, :user, :user_id
    rename_column :attendances, :event, :event_id
  end
end
