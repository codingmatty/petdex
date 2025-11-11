require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:species) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:species).of_type(:string) }
    it { is_expected.to have_db_column(:breed).of_type(:string) }
    it { is_expected.to have_db_column(:birth_date).of_type(:date) }
    it { is_expected.to have_db_column(:adoption_date).of_type(:date) }
    it { is_expected.to have_db_column(:microchip_number).of_type(:string) }
    it { is_expected.to have_db_column(:sex).of_type(:string) }
    it { is_expected.to have_db_column(:neutered).of_type(:boolean) }
    it { is_expected.to have_db_column(:color_markings).of_type(:text) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  describe 'factory' do
    it 'creates a valid pet' do
      pet = build(:pet)
      expect(pet).to be_valid
    end

    it 'creates a valid cat' do
      pet = build(:pet, :cat)
      expect(pet).to be_valid
      expect(pet.species).to eq('Cat')
    end
  end
end
