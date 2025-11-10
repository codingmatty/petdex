require 'rails_helper'

RSpec.describe "User Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "returns success" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      end

      it "creates a new user" do
        expect {
          post user_registration_path, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "signs in the new user" do
        post user_registration_path, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          email: "invalid",
          password: "short",
          password_confirmation: "different"
        }
      end

      it "does not create a new user" do
        expect {
          post user_registration_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "renders the new template" do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
