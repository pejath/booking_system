class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :email, uniqueness: true, null: false
      t.date :birthdate
      t.string :phone_number
      t.integer :role, default: 0

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end