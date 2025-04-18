class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :discount_code, optional: true
  has_many :participants, dependent: :destroy
  has_one :receipt, dependent: :destroy


  enum payment_method: { upi: 'upi', credit_card: 'credit_card' }
  enum payment_status: { pending: 'pending', completed: 'completed', failed: 'failed' }

  accepts_nested_attributes_for :participants

  before_save :calculate_amount_paid, if: -> { amount_paid.blank? }

  private

  def calculate_amount_paid
    base_price = if event.early_bird_deadline.present? && Time.current < event.early_bird_deadline
                   event.early_bird_price
                 else
                   event.price
                 end

    total = base_price * number_of_participants

     # Apply discount code if valid
  if discount_code&.available?
    total -= if discount_code.flat?
               discount_code.amount
             else
               (total * discount_code.amount / 100.0)
             end
    discount_code.use!
  end

  self.amount_paid = total.clamp(0, Float::INFINITY)
end
end
