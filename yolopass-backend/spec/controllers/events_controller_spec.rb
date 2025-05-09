require 'rails_helper'

RSpec.describe Organizer::EventsController, type: :request do
  let(:organizer) { create(:user, role: 'organizer') }
  let(:auth_headers) { { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: organizer.id)}" } }

  let(:valid_attributes) do
    {
      name: 'Tech Fest',
      description: 'Annual technology festival',
      venue: 'Pune',
      start_time: Time.now + 1.day,
      end_time: Time.now + 2.days,
      category: 'Technology',
      subcategory: 'Conference',
      price: 200,
      early_bird_discount: 20,
      early_bird_deadline: Time.now + 12.hours,
      max_participants: 100,
      id_proof_required: true
    }
  end

  let(:invalid_attributes) { valid_attributes.except(:name) }

  before do
    # simulate login (you can also use Devise::Test::IntegrationHelpers if using Devise)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(organizer)
  end

  describe 'POST /organizer/events' do
    context 'with valid parameters' do
      it 'creates a new Event' do
        expect {
          post '/organizer/events', params: { event: valid_attributes }, headers: auth_headers
        }.to change(Event, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('Tech Fest')
      end
    end

    context 'with invalid parameters' do
      it 'does not create an event' do
        post '/organizer/events', params: { event: invalid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'GET /organizer/events' do
    it 'returns the organizer\'s events' do
      create(:event, user: organizer)
      get '/organizer/events', headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe 'GET /organizer/events/:id' do
    let(:event) { create(:event, user: organizer) }

    it 'shows the event details' do
      get "/organizer/events/#{event.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(event.id)
    end
  end

  describe 'PATCH /organizer/events/:id' do
    let(:event) { create(:event, user: organizer) }

    it 'updates the event' do
      patch "/organizer/events/#{event.id}", params: { event: { name: 'Updated Event' } }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Updated Event')
    end
  end

  describe 'DELETE /organizer/events/:id' do
    let!(:event) { create(:event, user: organizer) }

    it 'deletes the event' do
      expect {
        delete "/organizer/events/#{event.id}", headers: auth_headers
      }.to change(Event, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
