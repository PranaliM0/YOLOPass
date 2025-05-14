# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::VenuesController, type: :controller do
  let!(:venue) { create(:venue) }
  let(:valid_params) do
    {
      venue: {
        name: "Test Venue",
        location: "123 Test St, Test City",
        capacity: 100,
        description: "A test venue for events"
      }
    }
  end
  let(:invalid_params) do
    {
      venue: {
        name: "",
        location: "",
        capacity: nil,
        description: ""
      }
    }
  end

  
  before do
    user = create(:user, :admin) # Create an admin user using the FactoryBot trait
    sign_in_user(user)           # Sign in the admin user
  end

  describe "GET #index" do
    it "returns a list of venues" do
      get :index

      expect(response).to be_successful
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body).first["id"]).to eq(venue.id)
    end
  end

  describe "GET #show" do
    it "returns a specific venue" do
      get :show, params: { id: venue.id }

      expect(response).to be_successful
      expect(JSON.parse(response.body)["id"]).to eq(venue.id)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new venue and returns created status" do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["name"]).to eq("Test Venue")
        expect(Venue.last.name).to eq("Test Venue")
      end
    end

    context "with invalid parameters" do
      it "does not create a venue and returns errors" do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "PATCH #update" do
    it "updates an existing venue" do
      patch :update, params: { id: venue.id, venue: { name: "Updated Venue" } }

      expect(response).to be_successful
      expect(JSON.parse(response.body)["name"]). to eq("Updated Venue")
      expect(venue.reload.name).to eq("Updated Venue")
    end

    it "returns an error when updating with invalid parameters" do
      patch :update, params: { id: venue.id, venue: invalid_params[:venue] }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key("errors")
    end
  end

  describe "DELETE #destroy" do
    it "deletes a venue" do
      delete :destroy, params: { id: venue.id }

      expect(response).to have_http_status(:no_content)
      expect { venue.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end