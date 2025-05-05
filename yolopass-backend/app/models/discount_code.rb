class DiscountCode < ApplicationRecord
  belongs_to :event

  validates :code, presence: true
  validates :discount_type, inclusion: { in: ["percentage", "fixed"] }
  validates :amount, numericality: { greater_than: 0 }
  validates :max_uses, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates_uniqueness_of :code, scope: :event_id, message: 'has already been taken for this event'

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def usable?
    !expired? && (max_uses.nil? || times_used < max_uses)
  end

  def apply_discount(original_amount)
    return original_amount unless usable?

    if percentage?
      original_amount - (original_amount * amount / 100)
    elsif fixed?
      [original_amount - amount, 0].max
    else
      original_amount
    end
  end

  def valid_for_early_bird?
    return false unless event.early_bird_deadline
    Time.current < event.early_bird_deadline
  end

  def valid_for_event?(event)
    self.event_id == event.id && self.expires_at > Time.now && self.times_used < self.max_uses
  end

  def use!
    return if expired? || (max_uses.present? && times_used >= max_uses)
    increment!(:times_used)
  end

  # ✅ Add these two predicate methods
  def percentage?
    discount_type == "percentage"
  end

  def fixed?
    discount_type == "fixed"
  end
end
