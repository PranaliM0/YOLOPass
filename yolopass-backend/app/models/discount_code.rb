class DiscountCode < ApplicationRecord
  has_many :registrations

  enum discount_type: { flat: 'flat', percentage: 'percentage' }

  def expired?
    expires_at.present? && Time.current > expires_at
  end

  def available?
    (max_uses.nil? || times_used < max_uses) && !expired?
  end

  def use!
    increment!(:times_used)
  end
end
