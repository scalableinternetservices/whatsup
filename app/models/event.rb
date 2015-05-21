class Event < ActiveRecord::Base

  belongs_to :user
  has_many :event_categories, :dependent => :destroy
  has_many :notifications
  geocoded_by :location
  after_validation :geocode
  validates :name, presence: true
  validates :location, presence: true
  validate :validate_end_after_start
  # => TODO: Require the user to select categories
  
  def validate_end_after_start
    if (self.end_time <= self.start_time)
      errors.add(:end_time, "must be after the start time.") 
      return false
    elsif (self.start_time < Time.now)
      errors.add(:start_time, "must not be in the past.") 
      return false
    end
  end
end
