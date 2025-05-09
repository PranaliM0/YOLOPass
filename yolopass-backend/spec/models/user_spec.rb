require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:registrations).dependent(:destroy) }
    it { should have_many(:events).through(:registrations) }
    it { should have_many(:organized_events).class_name('Event').with_foreign_key('user_id') }
  end

  describe "validations" do
    subject { build(:user) }  # ensures uniqueness test works correctly

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:name) }
    #it { should validate_inclusion_of(:role).in_array(User.roles.keys) }
    it "has a valid role" do
      expect(User.roles.keys).to include("admin", "organizer", "attendee")
    end    
  end

  describe "password authentication" do
    let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

    it "authenticates with correct password" do
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      expect(user.authenticate("wrongpass")).to be_falsey
    end
  end

  describe "roles" do
    it "has all defined roles" do
      expect(User.roles.keys).to match_array(%w[admin organizer attendee])
    end

    it "uses enum helper methods" do
      user = build(:user, role: :organizer)
      expect(user.organizer?).to be true
      expect(user.attendee?).to be false
    end
  end
end
