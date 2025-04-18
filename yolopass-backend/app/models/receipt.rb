class Receipt < ApplicationRecord
  belongs_to :registration

  enum payment_method: { upi: 0, credit_card: 1 }

  before_create :generate_receipt_number, :set_generated_at

  private

  def generate_receipt_number
    last_receipt = Receipt.order(:created_at).last
    sequence = last_receipt ? last_receipt.id + 1 : 1
    self.receipt_number = "YOLO#{Time.current.year}#{sequence.to_s.rjust(4, '0')}"
  end

  def set_generated_at
    self.generated_at = Time.current
  end
end
