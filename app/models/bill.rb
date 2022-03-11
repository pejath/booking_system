class Bill < ApplicationRecord
  enum status: %i[pending paid canceled]
  belongs_to :client

  monetize :final_price_cents, as: 'final_price'
  validates :final_price, numericality: { greater_than: 0 }

  def self.final_price(request, apartments)
    client = request.client.id
    final_price = (request.eviction_date - request.check_in_date)/86400 * apartments.price_cents
    Bill.create(client_id: client, final_price: final_price)
  end
end

