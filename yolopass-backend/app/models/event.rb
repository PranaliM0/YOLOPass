class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: "user_id"

  enum category: { concerts: 0, tech: 1, art: 2 }
  enum status: { open: 0, closed: 1 }

  validates :name, :venue, :start_time, :end_time, :category, :status, presence: true
end
