class CreateAdministrators < ActiveRecord::Migration[6.1]
  def change
    create_table :administrators do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
