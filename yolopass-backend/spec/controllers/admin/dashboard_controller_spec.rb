require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  before do
    user = create(:user, :admin) # Create an admin user using the FactoryBot trait
    sign_in_user(user)           # Sign in the admin user
  end

  describe "GET #stats" do
    it "returns the correct statistics" do
      # Create test data
      create_list(:user, 5) # Create 5 users
      create_list(:event, 3) # Create 3 events
      create_list(:user, 2, :organizer) # Create 2 organizers

      # Make the request
      get :stats

      # Parse the response
      json_response = JSON.parse(response.body)

      # Expectations
      expect(response).to have_http_status(:ok)
      expect(json_response["total_users"]).to eq(7) # 5 users + 2 organizers
      expect(json_response["total_events"]).to eq(3)
      expect(json_response["total_organizers"]).to eq(2)
    end
  end
end