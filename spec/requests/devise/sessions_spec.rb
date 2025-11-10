require 'rails_helper'

RSpec.describe "User Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    it "returns success" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "signs in the user" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "wrongpassword"
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "signs out the user" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
