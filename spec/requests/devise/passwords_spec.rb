require 'rails_helper'

RSpec.describe "Password Reset", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/password/new" do
    it "returns success" do
      get new_user_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users/password" do
    context "with valid email" do
      it "sends password reset instructions" do
        expect {
          post user_password_path, params: {
            user: { email: user.email }
          }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to sign in page" do
        post user_password_path, params: {
          user: { email: user.email }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with non-existent email" do
      it "returns unprocessable entity status" do
        post user_password_path, params: {
          user: { email: "nonexistent@example.com" }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not send an email" do
        expect {
          post user_password_path, params: {
            user: { email: "nonexistent@example.com" }
          }
        }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end

  describe "GET /users/password/edit" do
    let(:reset_token) { user.send(:set_reset_password_token) }

    context "with valid token" do
      it "returns success" do
        get edit_user_password_path(reset_password_token: reset_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid token" do
      it "renders the edit page" do
        get edit_user_password_path(reset_password_token: "invalid")
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PUT /users/password" do
    let(:reset_token) { user.send(:set_reset_password_token) }

    context "with matching passwords" do
      it "updates the password" do
        expect {
          put user_password_path, params: {
            user: {
              reset_password_token: reset_token,
              password: "newpassword123",
              password_confirmation: "newpassword123"
            }
          }
          user.reload
        }.to change { user.encrypted_password }
      end

      it "signs in the user" do
        put user_password_path, params: {
          user: {
            reset_password_token: reset_token,
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with non-matching passwords" do
      it "does not update the password" do
        original_password = user.encrypted_password
        put user_password_path, params: {
          user: {
            reset_password_token: reset_token,
            password: "newpassword123",
            password_confirmation: "different123"
          }
        }
        user.reload
        expect(user.encrypted_password).to eq(original_password)
      end

      it "renders the edit page" do
        put user_password_path, params: {
          user: {
            reset_password_token: reset_token,
            password: "newpassword123",
            password_confirmation: "different123"
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
