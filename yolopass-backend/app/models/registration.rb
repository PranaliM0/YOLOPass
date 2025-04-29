class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :discount_code, optional: true
  has_many :participants, dependent: :destroy
  has_one :receipt, dependent: :destroy
  has_one :payment, dependent: :destroy

  enum payment_method: { upi: 'upi', credit_card: 'credit_card' }
  enum payment_status: { pending: 'pending', completed: 'completed', failed: 'failed' }

  validates :payment_status, inclusion: { in: payment_statuses.keys }

  accepts_nested_attributes_for :participants

  before_save :calculate_amount_paid, if: -> { amount_paid.blank? }
  after_create :create_payment

  # Ensure default payment_status is set
  before_validation :set_default_payment_status, on: :create

  def amount_to_pay
    calculate_amount_paid
    amount_paid
  end
  private

  def calculate_amount_paid
    base_price = if event.early_bird_deadline.present? && Time.current <= event.early_bird_deadline
                   event.early_bird_price
                 else
                   event.price
                 end
  
    Rails.logger.debug "Base price: #{base_price}, Event price: #{event.price}, Early bird price: #{event.early_bird_price}"
  
    total = base_price * (self.number_of_participants || 1)
  
    Rails.logger.debug "Total before discount: #{total}"
  
    # Apply discount if applicable
    if discount_code&.usable? && Time.current > (event.early_bird_deadline || Time.current - 1.day)
      Rails.logger.debug "Applying discount: #{discount_code.amount} #{discount_code.discount_type}"
  
      if discount_code.discount_type == 'fixed'
        total -= discount_code.amount if discount_code.amount.to_f > 0
      elsif discount_code.discount_type == 'percent' && discount_code.amount.to_f > 0
        total -= total * (discount_code.amount / 100.0)
      end
    end
  
    self.amount_paid = total.clamp(0, Float::INFINITY)
    Rails.logger.debug "Final amount paid: #{self.amount_paid}"
  end
  
  

  # Set default payment status if not provided
  def set_default_payment_status
    self.payment_status ||= 'pending'
  end

  def create_payment
    create_payment!(
      amount: amount_paid,
      status: 'pending',
      payment_method: payment_method
    )
  end
end
