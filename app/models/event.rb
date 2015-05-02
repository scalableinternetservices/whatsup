class Event < ActiveRecord::Base
  belongs_to :user
  validates :name, :location, presence: true
  validates_datetime :end_time, :between => [:start_time, :now]
end
