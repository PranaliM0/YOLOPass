class User < ApplicationRecord
  has_secure_password

  has_many :events, foreign_key: :user_id

  #role enum
  enum role: { attendee: 0, organizer: 1, admin: 2 }

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: roles.keys }

end
