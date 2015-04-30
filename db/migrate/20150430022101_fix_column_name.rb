class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :Attendances, :user, :user_id
    rename_column :Attendances, :event, :event_id
  end
end
