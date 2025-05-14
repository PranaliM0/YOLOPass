require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    user = create(:user, :admin) # Create an admin user using the FactoryBot trait
    sign_in_user(user) 
    #byebug     1     # Sign in the admin user
  end

  describe "GET #index" do
    it "returns a list of all users" do
      create_list(:user, 5)

      get :index
      #byebug 6 admin,attendee,attendee,attendee,attendee,attendee
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(5)
    end
  end 

  describe "GET #event_registrations" do
    it "returns a list of events with their registrations" do
      #byebug 1 admin
      event = create(:event)
      #byebug 2 admin,attendee
      create_list(:registration, 3, event: event)
      #byebug 5 
      get :event_registrations
      #byebug 5 admin,attendee,attendee,attendee,attendee
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      #byebug 
      expect(json_response[0]["registrations"].size).to eq(3)
      #byebug
    end
  end

  describe "GET #unregistered_users" do
  #byebug
    let!(:registered_user) { create(:user, :attendee) }
    let!(:unregistered_user) { create(:user, :attendee) }
   # byebug

    # Register only one attendee
    #let!(:registration) { create(:registration, user: registered_user) }
    let!(:event) { create(:event, organizer: registered_user) } # Use the registered_user as the organizer
    let!(:registration) { create(:registration, user: registered_user, event: event) }
    it "returns a list of unregistered attendees only" do
      #byebug
      # Create attendees
      #byebug 1 admin
      # registered_user = create(:user, :attendee)
      #byebug 2 admin,attendee
      # unregistered_user = create(:user, :attendee)
      #byebug 
      # Send request
      get :unregistered_users
      #byebug
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
      expect(json_response.first["id"]).to eq(unregistered_user.id)
    end
  end


  describe "DELETE #destroy" do
    it "does not allow deleting an admin user" do
      admin_user = create(:user, :admin)

      delete :destroy, params: { id: admin_user.id }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t('admin.users.destroy.success'))
      expect(User.find_by(id: admin_user.id)).not_to be_nil
    end

    it "deletes a non-admin user" do
      attendee_user = create(:user, :attendee)

      delete :destroy, params: { id: attendee_user.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t('admin.users.destroy.cannot_delete_admin'))
      expect(User.find_by(id: attendee_user.id)).to be_nil
    end
  end
end