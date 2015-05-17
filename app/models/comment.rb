class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  validates :message, length: { minimum: 1 }
  validates :event_id, presence: true
  validates :user_id, presence: true
    
end
