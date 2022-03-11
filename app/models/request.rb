class Request < ApplicationRecord
  before_validation :period
  enum apartment_class: %i[A B C Luxe]
  enum status: %i[pending in_progress approved canceled]
  belongs_to :client

  validates :apartment_class, presence: true
  validates :number_of_beds, presence: true, numericality: { only_integer: true }
  validates :check_in_date, presence: true#, format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }
  validates :eviction_date, presence: true#, format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }

  def period
    if (eviction_date - check_in_date)/86_400 < 1
      errors.add(:date, 'incorrect period')
    else
      self.residence_time = ((eviction_date - check_in_date)/86_400).round.to_s
    end
  end

end
