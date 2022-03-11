class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string :residence_time, null: false
      t.integer :apartment_class, null: false
      t.integer :number_of_beds, null: false
      t.timestamp :check_in_date, null: false
      t.timestamp :eviction_date, null: false
      t.integer :status, null: false, default: :pending

      t.timestamps
    end
  end
end
