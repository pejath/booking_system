class Hotel < ApplicationRecord
  has_many :apartments

  validates :name, presence: true
  validates :rating, numericality: { numericality: true, greater_than: 0, less_than: 6 }
end
