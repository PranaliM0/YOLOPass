# spec/models/discount_code_spec.rb
require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  # Use FactoryBot to create an event and discount code
  let(:event) { create(:event) }
  let(:discount_code) { create(:discount_code, event: event) }

  describe 'validations' do
    subject { build(:discount_code, event: event, code: 'UNIQUECODE', discount_type: 'percentage', amount: 10) }
  
    it { should validate_presence_of(:code) }
  
    it {
      should validate_uniqueness_of(:code)
        .scoped_to(:event_id)
        .with_message('Code must be unique per event')
    }
  
    it { should validate_inclusion_of(:discount_type).in_array(%w[percentage fixed]) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_numericality_of(:max_uses).only_integer.is_greater_than(0).allow_nil }
  end
  
  
  describe 'uniqueness validation' do
    it 'is invalid if the code is not unique within the scope of event_id' do
      # Create another DiscountCode with the same event and code to test uniqueness validation
      duplicate_discount_code = build(:discount_code, event: event, code: discount_code.code)

      # Validate the uniqueness and check the errors
      expect(duplicate_discount_code).not_to be_valid
      expect(duplicate_discount_code.errors[:code]).to include('has already been taken for this event')
    end
  end
  
  describe 'methods' do
    describe '#expired?' do
      it 'returns true if the discount is expired' do
        discount_code.update(expires_at: Time.current - 1.day)
        expect(discount_code.expired?).to be true
      end

      it 'returns false if the discount is not expired' do
        discount_code.update(expires_at: Time.current + 1.day)
        expect(discount_code.expired?).to be false
      end
    end

    describe '#usable?' do
      it 'returns false if the discount is expired' do
        discount_code.update(expires_at: Time.current - 1.day)
        expect(discount_code.usable?).to be false
      end

      it 'returns true if the discount is not expired' do
        discount_code.update(expires_at: Time.current + 1.day)
        expect(discount_code.usable?).to be true
      end

      it 'returns false if max_uses is exceeded' do
        discount_code.update(times_used: 6, max_uses: 5)
        expect(discount_code.usable?).to be false
      end

      it 'returns true if max_uses is not set' do
        discount_code.update(max_uses: nil)
        expect(discount_code.usable?).to be true
      end
    end

    describe '#apply_discount' do
      it 'applies percentage discount' do
        discount_code.update(discount_type: 'percentage', amount: 10)
        expect(discount_code.apply_discount(100)).to eq(90)
      end

      it 'applies fixed discount' do
        discount_code.update(discount_type: 'fixed', amount: 10)
        expect(discount_code.apply_discount(100)).to eq(90)
      end

      it 'does not allow negative amounts' do
        discount_code.update(discount_type: 'fixed', amount: 110)
        expect(discount_code.apply_discount(100)).to eq(0)
      end

      it 'does not apply discount if discount is not usable' do
        discount_code.update(discount_type: 'fixed', amount: 10, expires_at: Time.current - 1.day)
        expect(discount_code.apply_discount(100)).to eq(100)
      end
    end

    describe '#use!' do
      it 'increments times_used by 1' do
        expect { discount_code.use! }.to change { discount_code.reload.times_used }.by(1)
      end

      it 'does nothing if the discount is expired' do
        discount_code.update(expires_at: Time.current - 1.day)
        expect { discount_code.use! }.not_to change { discount_code.reload.times_used }
      end

      it 'does nothing if max_uses is exceeded' do
        discount_code.update(times_used: 5, max_uses: 5)
        expect { discount_code.use! }.not_to change { discount_code.reload.times_used }
      end
    end

    describe '#valid_for_early_bird?' do
      it 'returns true if the event is before the early bird deadline' do
        event.update(early_bird_deadline: Time.current + 1.day)
        expect(discount_code.valid_for_early_bird?).to be true
      end

      it 'returns false if the event is after the early bird deadline' do
        event.update(early_bird_deadline: Time.current - 1.day)
        expect(discount_code.valid_for_early_bird?).to be false
      end
    end
  end
end
