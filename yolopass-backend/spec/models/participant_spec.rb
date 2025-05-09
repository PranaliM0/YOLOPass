require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:participant) { create(:participant) }

  describe 'associations' do
    it { should belong_to(:registration) }
    it { should have_one_attached(:uploaded_id) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:id_proof_type) }
  end

  describe 'factory' do
    it 'is valid with valid attributes' do
      expect(participant).to be_valid
    end

    it 'has an attached uploaded_id' do
      expect(participant.uploaded_id).to be_attached
    end
  end
end
