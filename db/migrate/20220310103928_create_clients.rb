class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :surname
      t.string :email, uniqueness: true, null: false
      t.date :birthdate
      t.string :phone_number

      t.timestamps
    end
    add_index :clients, :email, unique: true
  end
end
