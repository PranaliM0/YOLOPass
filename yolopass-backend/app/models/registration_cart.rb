class RegistrationCart < ApplicationRecord
  belongs_to :user
belongs_to :event
belongs_to :registration
belongs_to :discount_code, optional: true


  enum payment_status: { pending: 'pending', completed: 'completed', cancelled: 'cancelled' }

  # Calculates the total price in the cart
  def total_amount
    base_price = event.early_bird_deadline.present? && Time.current <= event.early_bird_deadline ? event.early_bird_price : event.price
    base_price.to_f * number_of_participants
  end
end
