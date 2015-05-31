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

  # for image attachment for events
  has_attached_file :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  def validate_end_after_start
    if (self.end_time <= self.start_time)
      errors.add(:end_time, "must be after the start time.") 
      return false
    elsif (self.end_time < Time.now)
      errors.add(:end_time, "must not be in the past.") 
      return false
    end
  end
end
