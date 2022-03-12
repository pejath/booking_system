class Hotel < ApplicationRecord
  has_many :apartments
  has_one_attached :image

  validates :name, presence: true
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
end
