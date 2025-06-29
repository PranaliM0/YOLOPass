require 'rails_helper'

RSpec.describe Organizer::EventsController, type: :controller do
  let(:organizer) { create(:user, role: 'organizer') }
  let(:event) { create(:event, user_id: organizer.id) }

  let(:valid_attributes) do
    {
      name: 'Sample Event',
      description: 'This is a sample event.',
      venue: 'Sample Venue',
      start_time: Time.now + 1.day,
      end_time: Time.now + 2.days,
      category: 'tech',
      subcategory: 'AI',
      price: 100.0,
      early_bird_discount: 10,
      early_bird_deadline: Time.now + 12.hours,
      max_participants: 100,
      id_proof_required: true
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      start_time: nil,
      end_time: nil
    }
  end

  before do
    sign_in_user(organizer) # Simulate the organizer being signed in
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new event' do
        expect {
          post :create, params: { event: valid_attributes }
        }.to change(Event, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(valid_attributes[:name])
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new event' do
        post :create, params: { event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'GET #index' do
    it 'returns all events for the current user' do
      event # Ensure the event is created
      get :index
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.first['name']).to eq(event.name)
    end
  end

  describe 'GET #show' do
    context 'when the event exists' do
      it 'returns the event' do
        get :show, params: { id: event.id }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(event.name)
      end
    end

    context 'when the event does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq(I18n.t('organizer.events.event_details.not_found'))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the event' do
        patch :update, params: { id: event.id, event: { name: 'Updated Event Name' } }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Event Name')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the event' do
        patch :update, params: { id: event.id, event: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the event exists' do
      it 'deletes the event' do
        event # Ensure the event is created
        expect {
          delete :destroy, params: { id: event.id }
        }.to change(Event, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the event does not exist' do
      it 'returns a not found error' do
        delete :destroy, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq(I18n.t('organizer.events.destroy.not_deleted'))
      end
    end
  end
end