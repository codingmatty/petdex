class Note < ApplicationRecord
  belongs_to :pet

  validates :content, presence: true
  validates :note_date, presence: true

  default_scope { order(note_date: :desc) }
end
