class CreateAdministrators < ActiveRecord::Migration[6.1]
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :surname
      t.string :email, uniqueness: true, null: false

      t.timestamps
    end
    add_index :administrators, :email, unique: true
  end
end
