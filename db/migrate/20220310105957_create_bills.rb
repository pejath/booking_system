class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.belongs_to :client
      t.monetize :final_price, null: false
      t.integer :status, default: :pending

      t.timestamps
    end
  end
end
