class Payment < ApplicationRecord
  belongs_to :registration

  enum status: { pending: 'pending', completed: 'completed', failed: 'failed' }

  validates :amount, presence: true
  validates :status, presence: true
  validates :payment_method, presence: true
end
