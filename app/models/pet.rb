class Pet < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :name, presence: true
  validates :species, presence: true
end
