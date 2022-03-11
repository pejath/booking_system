class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :email, null: false
      t.date :birthdate, null: false
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
