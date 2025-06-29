require 'rails_helper'

RSpec.describe Organizer::OrganizersController, type: :controller do
  let(:organizer) { create(:user, role: 'organizer') }
  let(:attendee) { create(:user, role: 'attendee') }

  before do
    sign_in_user(organizer) # Simulate the organizer being signed in
  end

  describe 'GET #profile' do
    context 'when the user is an organizer' do
      let(:current_user) { organizer }

      it 'returns the organizer profile and summary' do
        create_list(:event, 3, user_id: organizer.id, status: 'open')
        create_list(:event, 2, user_id: organizer.id, status: 'closed')
        create_list(:registration, 5, event: create(:event, user_id: organizer.id))

        get :profile

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response['organizer']['id']).to eq(organizer.id)
        expect(json_response['organizer']['name']).to eq(organizer.name)
        expect(json_response['organizer']['email']).to eq(organizer.email)
        expect(json_response['organizer']['role']).to eq('organizer')

        expect(json_response['summary']['total']).to eq(5)
        expect(json_response['summary']['open']).to eq(3)
        expect(json_response['summary']['closed']).to eq(2)
        expect(json_response['summary']['participants']).to eq(5)
      end
    end

    context 'when the user is not an organizer' do
      let(:current_user) { attendee }

      it 'returns an unauthorized error' do
        get :profile

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq(I18n.t('organizer.organizers.profile.not_authorized'))
      end
    end
  end
end