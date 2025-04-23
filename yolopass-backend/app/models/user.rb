class User < ApplicationRecord
  has_secure_password #will automatically add methods like password,password_confirmation

  has_many :organized_events, class_name: 'Event', foreign_key: 'user_id'
  #role enum
  enum role: { admin: 0, organizer: 1, attendee: 2 }

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: roles.keys }

end
