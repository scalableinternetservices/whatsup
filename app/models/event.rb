class Event < ActiveRecord::Base

  belongs_to :user
  geocoded_by :location
  after_validation :geocode
  validates :name, presence: true
  #validates_datetime :end_time, :after => [:now, :start_time]
  validate :validate_end_after_start
  
  def validate_end_after_start
    if (self.end_time < self.start_time)
      errors.add(:end_time, "must be after the start time.") 
      return false
    end
  end
end
