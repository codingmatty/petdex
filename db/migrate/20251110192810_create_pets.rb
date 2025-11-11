class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.string :breed
      t.date :birth_date
      t.date :adoption_date
      t.string :microchip_number
      t.string :sex
      t.boolean :neutered
      t.text :color_markings
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
