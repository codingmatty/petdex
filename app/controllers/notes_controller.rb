class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet
  before_action :authorize_pet
  before_action :set_note, only: [:destroy]

  def create
    @note = @pet.notes.build(note_params)

    if @note.save
      redirect_to @pet, notice: "Note added successfully."
    else
      redirect_to @pet, alert: "Failed to add note: #{@note.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @note.destroy
    redirect_to @pet, notice: "Note deleted successfully."
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def authorize_pet
    unless @pet.user == current_user
      redirect_to pets_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_note
    @note = @pet.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:content, :note_date)
  end
end
