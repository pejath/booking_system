class IncreaseLimitInApartments < ActiveRecord::Migration[6.1]
  def change
    change_column :apartments, :price_cents, :integer, limit: 8
  end
end
