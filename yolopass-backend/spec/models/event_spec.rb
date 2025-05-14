require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organizer) { create(:user) }

  describe 'associations' do
    #it { should belong_to(:venue).optional }
    it { should belong_to(:organizer).class_name('User') }
    it { should have_many(:registrations).dependent(:destroy) }
    it { should have_one_attached(:image) }
    it { should have_many(:discount_codes) }
    it { should have_many(:users).through(:registrations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    #it { should validate_presence_of(:venue) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it { should define_enum_for(:category).with_values(concerts: 0, tech: 1, art: 2) }
    it { should define_enum_for(:status).with_values(open: 0, closed: 1) }
  end

  describe 'default status' do
    it 'sets status to open by default' do
      event = Event.new
      expect(event.status).to eq('open')
    end
  end

  describe 'conflicting time validation' do
    let(:venue) { create(:venue) }

    it 'adds error if there is a time conflict at the same venue' do
      create(:event, venue: venue, start_time: 2.days.from_now, end_time: 3.days.from_now)
      event = build(:event, venue: venue, start_time: 2.days.from_now + 1.hour, end_time: 3.days.from_now + 1.hour)

      event.validate
      expect(event.errors[:base]).to include('This venue is already booked during the selected time slot.')
    end

    it 'does not add error if times do not overlap' do
      create(:event, venue: venue, start_time: 2.days.from_now, end_time: 3.days.from_now)
      event = build(:event, venue: venue, start_time: 3.days.from_now + 1.hour, end_time: 4.days.from_now)

      event.validate
      expect(event.errors[:base]).to be_empty
    end
  end

  describe '#early_bird_price' do
    it 'returns discounted price before deadline' do
      event = build(:event,
                    price: 1000,
                    early_bird_discount: 20,
                    early_bird_deadline: 1.day.from_now)

      expect(event.early_bird_price).to eq(800)
    end

    it 'returns full price after deadline' do
      event = build(:event,
                    price: 1000,
                    early_bird_discount: 20,
                    early_bird_deadline: 1.day.ago)

      expect(event.early_bird_price).to eq(1000)
    end
  end
end
