class User < ActiveRecord::Base
  
  #geocoded_by :location
  #after_validation :geocode

  validates :name, presence: true, length: { in: 6..50, too_long: "name is too long", too_short: "name is too short" }
   

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
    length: { maximum: 255 }, 
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  
  has_many :events

  has_secure_password
end
