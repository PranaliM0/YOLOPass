class Participant < ApplicationRecord
  belongs_to :registration

  validates :name, :email, :phone, presence: true
end
