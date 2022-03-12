class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.belongs_to :client
      t.monetize :final_price
      t.bigint :status, default: 0

      t.timestamps
    end
  end
end
