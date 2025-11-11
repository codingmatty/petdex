require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:pets).dependent(:destroy) }
  end

  describe 'Devise modules' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
    it { is_expected.to respond_to(:remember_created_at) }
    it { is_expected.to respond_to(:reset_password_token) }
    it { is_expected.to respond_to(:reset_password_sent_at) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
  end
end
