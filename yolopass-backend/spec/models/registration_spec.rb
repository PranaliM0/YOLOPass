require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
    it { should belong_to(:discount_code).optional }
    it { should have_many(:participants).dependent(:destroy) }
    it { should have_one(:receipt).dependent(:destroy) }
    it { should have_one(:payment).dependent(:destroy) }
  end

  it "has a valid payment method" do
    expect(Registration.payment_methods.keys).to include("upi", "credit_card")
  end 
 
  it "has a valid status" do
    expect(Registration.payment_statuses.keys).to include("pending", "completed", "failed")
  end 
  
  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:participants) }
  end

  describe 'callbacks' do
    context 'before_validation' do
      it 'sets default payment_status to pending if not provided' do
        registration = build(:registration, payment_status: 'pending')
        registration.valid?
        expect(registration.payment_status).to eq('pending')
      end
    end

    context 'after_create' do
      it 'creates a payment record' do
        registration = create(:registration, payment_method: 'upi') # Explicitly set payment_method
        expect(registration.payment).to be_present
        expect(registration.payment.amount).to eq(registration.amount_paid)
        expect(registration.payment.status).to eq('pending')
        expect(registration.payment.payment_method).to eq('upi')
      end
    end
  end

  describe '#amount_to_pay' do
  it 'returns the calculated amount_paid' do
    event = create(:event, price: 200, early_bird_discount: 100, early_bird_deadline: 1.day.from_now)
    registration = create(:registration, event: event, number_of_participants: 2)
    expect(registration.amount_to_pay).to eq(200) # 2 x 100 (early bird price)
  end
end

  describe '#calculate_amount_paid' do
    let(:event) { create(:event, price: 500, early_bird_discount: 300, early_bird_deadline: 1.day.ago) }

    it 'applies fixed discount when applicable' do
      discount = create(:discount_code, discount_type: 'fixed', amount: 100)
      allow_any_instance_of(DiscountCode).to receive(:usable?).and_return(true)

      registration = build(:registration, event: event, number_of_participants: 1, discount_code: discount)
      registration.send(:calculate_amount_paid)
      expect(registration.amount_paid).to eq(400)  # 500 - 100 discount
    end

    it 'applies percentage discount when applicable' do
      discount = create(:discount_code, discount_type: 'percentage', amount: 20)
      allow_any_instance_of(DiscountCode).to receive(:usable?).and_return(true)

      registration = build(:registration, event: event, number_of_participants: 1, discount_code: discount)
      registration.send(:calculate_amount_paid)
      expect(registration.amount_paid).to eq(400) # 500 - 20% = 400
    end

    it 'does not apply discount during early bird period' do
      event = create(:event, price: 500, early_bird_discount: 300, early_bird_deadline: 1.day.from_now)
      discount = create(:discount_code, discount_type: 'percentage', amount: 20)
      allow_any_instance_of(DiscountCode).to receive(:usable?).and_return(true)

      registration = build(:registration, event: event, number_of_participants: 1, discount_code: discount)
      registration.send(:calculate_amount_paid)
      expect(registration.amount_paid).to eq(300) # Early bird price only
    end
  end
end
