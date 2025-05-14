# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::EventsController, type: :controller do
  let!(:event) { create(:event) }
  let(:valid_params) do
    {
      event: {
        name: "Test Event",
        date: "2023-10-01",
        location: "123 Test St, Test City",
        description: "A test event for testing purposes"
      }
    }
  end
  let(:invalid_params) do
    {
      event: {
        name: "",
        date: "",
        location: "",
        description: ""
      }
    }
  end

  before do
    user = create(:user, :admin) # Create an admin user using the FactoryBot trait
    sign_in_user(user)           # Sign in the admin user
  end

  describe "GET #index" do
    it "returns a list of events" do
      get :index

      expect(response).to be_successful
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body).first["id"]).to eq(event.id)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the event and returns success message" do
      event = create(:event)
      delete :destroy, params: { id: event.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t('admin.events.destroy.success'))
    end

    it "returns not found message if event does not exist" do
      delete :destroy, params: { id: -1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t('admin.events.destroy.not_found'))
    end
  end
end