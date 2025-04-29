class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: "user_id"
  has_many :registrations, dependent: :destroy
  has_one_attached :image
  has_many :discount_codes
  has_many :users, through: :registrations
  enum category: { concerts: 0, tech: 1, art: 2 }
  enum status: { open: 0, closed: 1 }

  validates :name, :venue, :start_time, :end_time, :category, :status, presence: true
 # validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  # Set default status to 'open' if not provided
  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :open
  end
  
  #check event conflict
  validate :no_time_conflict_at_same_venue

  def no_time_conflict_at_same_venue
    return if start_time.blank? || end_time.blank? || venue.blank?
  
    overlapping_events = Event.where(venue: venue)
      .where.not(id: id) # exclude current record (for updates)
      .where("start_time < ? AND end_time > ?", end_time, start_time)
  
    if overlapping_events.exists?
      errors.add(:base, "This venue is already booked during the selected time slot.")
    end
  end

  def early_bird_price
    if Time.current <= early_bird_deadline
      price - (price * early_bird_discount / 100.0)
    else
      price
    end
  end
  
end
