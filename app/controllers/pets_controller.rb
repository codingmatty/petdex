class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: [:show, :edit, :update, :destroy]
  before_action :authorize_pet, only: [:show, :edit, :update, :destroy]

  def index
    @pets = current_user.pets
  end

  def new
    @pet = current_user.pets.build
  end

  def create
    @pet = current_user.pets.build(pet_params)

    if @pet.save
      redirect_to @pet, notice: "Pet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @pet.update(pet_params)
      redirect_to @pet, notice: "Pet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_url, notice: "Pet was successfully deleted."
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def authorize_pet
    unless @pet.user == current_user
      redirect_to pets_path, alert: "You are not authorized to perform this action."
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :species, :breed, :birth_date, :adoption_date, :microchip_number, :sex, :neutered, :color_markings)
  end
end
