class CreateApartments < ActiveRecord::Migration[6.1]
  def change
    create_table :apartments do |t|
      t.belongs_to :hotel
      t.integer :apartment_class, null: false
      t.integer :room_number, null: false
      t.monetize :price, null: false

      t.timestamps
    end
  end
end
