class Bill < ApplicationRecord
  include ActiveSupport
  before_validation :calculate_final_price

  enum status: %i[pending paid canceled]
  belongs_to :request
  belongs_to :apartment

  monetize :final_price_cents, as: 'final_price'
  validates :final_price, presence: true, numericality: { greater_than: 0 }

  private

  def calculate_final_price
    return unless request && apartment
    if final_price <= 0
      self.final_price = Duration.parse(request.residence_time).in_days.round(2) * apartment.price_cents
    end
  end

end

