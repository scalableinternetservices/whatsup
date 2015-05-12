class Event < ActiveRecord::Base

  belongs_to :user
  geocoded_by :location
  after_validation :geocode
  validates :name, presence: true
  validates_datetime :end_time, :between => [:start_time, :now]
  has_many :comments
end
