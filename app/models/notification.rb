class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :from_user_id, presence: true
  validates :event_id, presence: true
  validates :message, length: { minimum: 1 }
end
