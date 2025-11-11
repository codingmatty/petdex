require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:pet) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:note_date) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:content).of_type(:text) }
    it { is_expected.to have_db_column(:note_date).of_type(:date) }
    it { is_expected.to have_db_column(:pet_id).of_type(:integer) }
  end

  describe 'default scope' do
    let(:pet) { create(:pet) }

    it 'orders notes by date descending' do
      note1 = create(:note, pet: pet, note_date: 1.day.ago)
      note2 = create(:note, pet: pet, note_date: 3.days.ago)
      note3 = create(:note, pet: pet, note_date: 2.days.ago)

      expect(pet.notes.to_a).to eq([note1, note3, note2])
    end
  end
end
