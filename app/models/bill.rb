class Bill < ApplicationRecord
  enum status: %i[pending paid canceled]
  belongs_to :client

  def self.final_price(request, apartments)
    client = request.client.id
    final_price = request.residence_time.to_i * apartments.price_cents
    Bill.create(client_id: client, final_price_cents: final_price)
  end
end
