require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            name: "Test User",
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123",
            role: "attendee"
          }
        }
      end

      it "creates a new user and returns created status" do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t('users.create.users_created'))
        expect(User.last.email).to eq("test@example.com")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "",
            password: "123",
            password_confirmation: "456",
            role: ""
          }
        }
      end

      it "does not create a user and returns errors" do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end
end
