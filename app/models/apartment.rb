class Apartment < ApplicationRecord
  enum apartment_class: %i[A B C Luxe]
  belongs_to :hotel

  monetize :price_cents, as: 'price'
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :room_number, presence: true, numericality: { only_integer: true }, uniqueness: { scope: :hotel_id }
end
