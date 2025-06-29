require 'rails_helper'

RSpec.describe Organizer::DiscountCodesController, type: :controller do
  let(:organizer) { create(:user, role: 'organizer') }
  let(:event) { create(:event, user_id: organizer.id) }
  let(:discount_code) { create(:discount_code, event: event) }

  let(:valid_attributes) do
    {
      code: 'DISCOUNT10',
      discount_type: 'percentage',
      amount: 10,
      expires_at: Time.now + 1.day,
      max_uses: 100,
      event_id: event.id
    }
  end

  let(:invalid_attributes) do
    {
      discount_type: 'percentage',
      amount: 10,
      expires_at: Time.now + 1.day,
      max_uses: 100,
      event_id: event.id # Ensure this is valid
    }
  end

  before do
    sign_in_user(organizer)           # Sign in the admin user
  end

  describe 'GET #index' do
  context 'with valid event_id' do
    it 'returns all discount codes for the event' do
      discount_code
      get :index, params: { event_id: event.id }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'code' => discount_code.code,
        'discount_type' => discount_code.discount_type
      )
    end
  end

  context 'without event_id' do
    it 'returns a bad request error' do
      get :index
      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq(I18n.t('organizer.discount_codes.index.missing_event_id'))
    end
  end
end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new discount code' do
        expect {
          post :create, params: { discount_code: valid_attributes }
        }.to change(DiscountCode, :count).by(1)
  
        expect(response).to have_http_status(:created)
        byebug
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('organizer.discount_codes.create.success'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a discount code' do
        post :create, params: { discount_code: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Code can't be blank")
      end
    end

    context 'when event is not found' do
      it 'returns a not found error' do
        post :create, params: { discount_code: valid_attributes.merge(event_id: 0) }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq(I18n.t('organizer.discount_codes.create.event_not_found'))
      end
    end
  end

  describe 'GET #show' do
    context 'when discount code exists' do
      it 'returns the discount code' do
        get :show, params: { id: discount_code.id, event_id: event.id }
        expect(response).to have_http_status(:ok)
        expect(json_response['discount_code']).to eq(discount_code)
      end
    end

    context 'when discount code does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 0, event_id: event.id }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq(I18n.t('organizer.discount_codes.show.not_found'))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the discount code' do
        patch :update, params: { id: discount_code.id, discount_code: { code: 'UPDATEDCODE' } }
        expect(response).to have_http_status(:ok)
        expect(json_response['discount_code.code']).to eq('UPDATEDCODE')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the discount code' do
        patch :update, params: { id: discount_code.id, discount_code: { code: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include(I18n.t('organizer.discount_codes.update.not_updated'))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the discount code' do
      discount_code # Ensure the discount code is created
      expect {
        delete :destroy, params: { id: discount_code.id, event_id: event.id }
      }.to change(DiscountCode, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end