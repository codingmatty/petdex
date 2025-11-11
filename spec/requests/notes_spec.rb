require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:pet) { create(:pet, user: user) }
  let(:note) { create(:note, pet: pet) }

  describe "POST /pets/:pet_id/notes" do
    context "when not logged in" do
      it "redirects to sign in" do
        post pet_notes_path(pet), params: { note: { content: "Test note", note_date: Date.today } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as pet owner" do
      before { sign_in user }

      context "with valid parameters" do
        let(:valid_params) do
          {
            note: {
              content: "Veterinary checkup completed",
              note_date: Date.today
            }
          }
        end

        it "creates a new note" do
          expect {
            post pet_notes_path(pet), params: valid_params
          }.to change(Note, :count).by(1)
        end

        it "associates the note with the pet" do
          post pet_notes_path(pet), params: valid_params
          expect(pet.notes.last.content).to eq("Veterinary checkup completed")
        end

        it "redirects to the pet page" do
          post pet_notes_path(pet), params: valid_params
          expect(response).to redirect_to(pet_path(pet))
        end

        it "shows a success notice" do
          post pet_notes_path(pet), params: valid_params
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) do
          {
            note: {
              content: "",
              note_date: ""
            }
          }
        end

        it "does not create a new note" do
          expect {
            post pet_notes_path(pet), params: invalid_params
          }.not_to change(Note, :count)
        end

        it "redirects to the pet page with alert" do
          post pet_notes_path(pet), params: invalid_params
          expect(response).to redirect_to(pet_path(pet))
          expect(flash[:alert]).to be_present
        end
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not create a note" do
        expect {
          post pet_notes_path(pet), params: { note: { content: "Test", note_date: Date.today } }
        }.not_to change(Note, :count)
      end

      it "redirects with an alert" do
        post pet_notes_path(pet), params: { note: { content: "Test", note_date: Date.today } }
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /pets/:pet_id/notes/:id" do
    context "when not logged in" do
      it "redirects to sign in" do
        delete pet_note_path(pet, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as pet owner" do
      before { sign_in user }

      it "destroys the note" do
        note # create note
        expect {
          delete pet_note_path(pet, note)
        }.to change(Note, :count).by(-1)
      end

      it "redirects to the pet page" do
        delete pet_note_path(pet, note)
        expect(response).to redirect_to(pet_path(pet))
      end

      it "shows a success notice" do
        delete pet_note_path(pet, note)
        expect(flash[:notice]).to be_present
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not destroy the note" do
        note # create note
        expect {
          delete pet_note_path(pet, note)
        }.not_to change(Note, :count)
      end

      it "redirects with an alert" do
        delete pet_note_path(pet, note)
        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
