require 'rails_helper'

RSpec.describe Admin::OrganizersController, type: :controller do
  before do
    user = create(:user, :admin) # Create an admin user using the FactoryBot trait
    sign_in_user(user)           # Sign in the admin user
  end

  describe "GET #index" do
    it "returns a list of organizers with their organized events" do
      organizer1 = create(:user, :organizer)
      organizer2 = create(:user, :organizer)
      create(:event, organizer: organizer1)
      create(:event, organizer: organizer2)

      get :index

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)
      expect(json_response[0]["id"]).to eq(organizer1.id)
      expect(json_response[1]["id"]).to eq(organizer2.id)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the organizer and their events" do
      organizer = create(:user, :organizer)
      create_list(:event, 3, organizer: organizer)

      delete :destroy, params: { id: organizer.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t('admin.organizers.destroy.success'))
      expect(User.find_by(id: organizer.id)).to be_nil
      expect(Event.where(organizer: organizer)).to be_empty
    end

    it "returns not found if the organizer does not exist" do
      delete :destroy, params: { id: -1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t('admin.organizers.destroy.not_found'))
    end
  end
end