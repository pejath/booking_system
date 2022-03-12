class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string :name, null: false
      t.integer :rating

      t.timestamps
    end
  end
end
