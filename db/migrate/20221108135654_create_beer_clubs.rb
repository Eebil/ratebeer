class CreateBeerClubs < ActiveRecord::Migration[7.0]
  def change
    create_table :beer_clubs do |t|
      t.string :name
      t.integer :founding_year
      t.string :city

      t.timestamps
    end
  end
end
