require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:pet) { create(:pet, user: user) }

  describe "GET /pets" do
    context "when not logged in" do
      it "redirects to sign in" do
        get pets_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      before { sign_in user }

      it "returns success" do
        get pets_path
        expect(response).to have_http_status(:success)
      end

      it "displays the user's pets" do
        pet # create pet
        get pets_path
        expect(response.body).to include(pet.name)
      end

      it "does not display other user's pets" do
        other_pet = create(:pet, user: other_user, name: "Other User Pet")
        get pets_path
        expect(response.body).not_to include(other_pet.name)
      end
    end
  end

  describe "GET /pets/new" do
    context "when not logged in" do
      it "redirects to sign in" do
        get new_pet_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      before { sign_in user }

      it "returns success" do
        get new_pet_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /pets" do
    context "when not logged in" do
      it "redirects to sign in" do
        post pets_path, params: { pet: { name: "Fido", species: "Dog" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      before { sign_in user }

      context "with valid parameters" do
        let(:valid_params) do
          {
            pet: {
              name: "Fido",
              species: "Dog",
              breed: "Golden Retriever",
              birth_date: "2020-01-01"
            }
          }
        end

        it "creates a new pet" do
          expect {
            post pets_path, params: valid_params
          }.to change(Pet, :count).by(1)
        end

        it "assigns the pet to the current user" do
          post pets_path, params: valid_params
          expect(Pet.last.user).to eq(user)
        end

        it "redirects to the pet page" do
          post pets_path, params: valid_params
          expect(response).to redirect_to(pet_path(Pet.last))
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) do
          {
            pet: {
              name: "",
              species: ""
            }
          }
        end

        it "does not create a new pet" do
          expect {
            post pets_path, params: invalid_params
          }.not_to change(Pet, :count)
        end

        it "renders the new template" do
          post pets_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET /pets/:id" do
    context "when not logged in" do
      it "redirects to sign in" do
        get pet_path(pet)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as the pet owner" do
      before { sign_in user }

      it "returns success" do
        get pet_path(pet)
        expect(response).to have_http_status(:success)
      end

      it "displays the pet details" do
        get pet_path(pet)
        expect(response.body).to include(pet.name)
        expect(response.body).to include(pet.species)
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "redirects with an alert" do
        get pet_path(pet)
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET /pets/:id/edit" do
    context "when not logged in" do
      it "redirects to sign in" do
        get edit_pet_path(pet)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as the pet owner" do
      before { sign_in user }

      it "returns success" do
        get edit_pet_path(pet)
        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "redirects with an alert" do
        get edit_pet_path(pet)
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH /pets/:id" do
    context "when not logged in" do
      it "redirects to sign in" do
        patch pet_path(pet), params: { pet: { name: "New Name" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as the pet owner" do
      before { sign_in user }

      context "with valid parameters" do
        it "updates the pet" do
          patch pet_path(pet), params: { pet: { name: "New Name" } }
          expect(pet.reload.name).to eq("New Name")
        end

        it "redirects to the pet page" do
          patch pet_path(pet), params: { pet: { name: "New Name" } }
          expect(response).to redirect_to(pet_path(pet))
        end
      end

      context "with invalid parameters" do
        it "does not update the pet" do
          original_name = pet.name
          patch pet_path(pet), params: { pet: { name: "" } }
          expect(pet.reload.name).to eq(original_name)
        end

        it "renders the edit template" do
          patch pet_path(pet), params: { pet: { name: "" } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not update the pet" do
        original_name = pet.name
        patch pet_path(pet), params: { pet: { name: "New Name" } }
        expect(pet.reload.name).to eq(original_name)
      end

      it "redirects with an alert" do
        patch pet_path(pet), params: { pet: { name: "New Name" } }
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /pets/:id" do
    context "when not logged in" do
      it "redirects to sign in" do
        delete pet_path(pet)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as the pet owner" do
      before { sign_in user }

      it "destroys the pet" do
        pet # create pet
        expect {
          delete pet_path(pet)
        }.to change(Pet, :count).by(-1)
      end

      it "redirects to the pets index" do
        delete pet_path(pet)
        expect(response).to redirect_to(pets_path)
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not destroy the pet" do
        pet # create pet
        expect {
          delete pet_path(pet)
        }.not_to change(Pet, :count)
      end

      it "redirects with an alert" do
        delete pet_path(pet)
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
