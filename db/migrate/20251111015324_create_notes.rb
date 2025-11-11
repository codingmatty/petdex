class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.text :content
      t.date :note_date
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
