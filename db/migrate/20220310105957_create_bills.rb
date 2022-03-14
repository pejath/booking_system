class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.belongs_to :request
      t.belongs_to :apartment
      t.monetize :final_price
      t.bigint :status, default: 0

      t.timestamps
    end
  end
end
