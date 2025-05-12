require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  let(:event) { create(:event, early_bird_deadline: 3.days.from_now) }

  subject {
    described_class.new(
      code: "SAVE20",
      discount_type: "percentage",
      amount: 20,
      max_uses: 5,
      times_used: 0,
      expires_at: 2.days.from_now,
      event: event
    )
  }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a code" do
      subject.code = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a discount_type" do
      subject.discount_type = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with invalid discount_type" do
      subject.discount_type = 'invalid_type'
      expect(subject).not_to be_valid
    end

    it "is not valid with non-positive amount" do
      subject.amount = 0
      expect(subject).not_to be_valid
    end

    it "is valid without max_uses (unlimited uses)" do
      subject.max_uses = nil
      expect(subject).to be_valid
    end

    it "is not valid with negative max_uses" do
      subject.max_uses = -1
      expect(subject).not_to be_valid
    end

    it "is not valid if code is not unique per event" do
      subject.save!
      duplicate = subject.dup
      expect(duplicate).not_to be_valid
    end
  end

  describe "#expired?" do
    it "returns true if the code is expired" do
      subject.expires_at = 1.day.ago
      expect(subject.expired?).to be true
    end

    it "returns false if the code is not expired" do
      subject.expires_at = 1.day.from_now
      expect(subject.expired?).to be false
    end

    it "returns false if expires_at is nil" do
      subject.expires_at = nil
      expect(subject.expired?).to be false
    end
  end

  describe "#usable?" do
    it "returns true if not expired and under usage limit" do
      subject.expires_at = 1.day.from_now
      subject.times_used = 2
      expect(subject.usable?).to be true
    end

    it "returns false if expired" do
      subject.expires_at = 1.day.ago
      expect(subject.usable?).to be false
    end

    it "returns false if usage limit reached" do
      subject.times_used = subject.max_uses
      expect(subject.usable?).to be false
    end

    it "returns true if max_uses is nil (unlimited)" do
      subject.max_uses = nil
      subject.times_used = 999
      expect(subject.usable?).to be true
    end
  end

  describe "#apply_discount" do
    context "with percentage discount" do
      it "applies correct percentage discount" do
        expect(subject.apply_discount(100)).to eq(80)
      end
    end

    context "with fixed discount" do
      it "applies fixed discount correctly" do
        subject.discount_type = "fixed"
        subject.amount = 30
        expect(subject.apply_discount(100)).to eq(70)
      end

      it "does not allow negative final amount" do
        subject.discount_type = "fixed"
        subject.amount = 150
        expect(subject.apply_discount(100)).to eq(0)
      end
    end

    it "does not apply discount if not usable" do
      subject.expires_at = 1.day.ago
      expect(subject.apply_discount(100)).to eq(100)
    end
  end

  describe "#valid_for_early_bird?" do
    it "returns true before early bird deadline" do
      event.early_bird_deadline = 2.days.from_now
      expect(subject.valid_for_early_bird?).to be true
    end

    it "returns false after early bird deadline" do
      event.early_bird_deadline = 1.day.ago
      expect(subject.valid_for_early_bird?).to be false
    end

    it "returns false if early_bird_deadline is nil" do
      event.early_bird_deadline = nil
      expect(subject.valid_for_early_bird?).to be false
    end
  end

  describe "#valid_for_event?" do
    it "returns true if valid for the same event" do
      expect(subject.valid_for_event?(event)).to be true
    end

    it "returns false if event is different" do
      another_event = create(:event)
      expect(subject.valid_for_event?(another_event)).to be false
    end

    it "returns false if expired or used up" do
      subject.expires_at = 1.day.ago
      subject.times_used = subject.max_uses
      expect(subject.valid_for_event?(event)).to be false
    end
  end

  describe "#use!" do
    it "increments times_used if usable" do
      expect { subject.use! }.to change(subject, :times_used).by(1)
    end

    it "does not increment if expired" do
      subject.expires_at = 1.day.ago
      expect { subject.use! }.not_to change(subject, :times_used)
    end

    it "does not increment if usage limit reached" do
      subject.times_used = subject.max_uses
      expect { subject.use! }.not_to change(subject, :times_used)
    end
  end

  describe "#percentage? and #fixed?" do
    it "returns true for percentage discount" do
      expect(subject.percentage?).to be true
      expect(subject.fixed?).to be false
    end

    it "returns true for fixed discount" do
      subject.discount_type = "fixed"
      expect(subject.fixed?).to be true
      expect(subject.percentage?).to be false
    end
  end
end
