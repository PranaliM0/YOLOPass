# spec/models/venue_spec.rb

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is invalid without a venue name' do
      event = Event.new(name: 'Test Event', start_time: Time.current, end_time: Time.current + 1.hour, category: :tech, status: :open, venue: nil)
      expect(event).not_to be_valid
      expect(event.errors[:venue]).to include("can't be blank")
    end
  end
end
