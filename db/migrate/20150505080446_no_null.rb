class NoNull < ActiveRecord::Migration
  def change
    change_column_null :attendances, :event_id, false
    change_column_null :attendances, :user_id, false
  end
end
