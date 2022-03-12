class Request < ApplicationRecord
  before_create :period # before_validation doesn't work in tests
  enum apartment_class: %i[A B C Luxe]
  enum status: %i[pending in_progress approved canceled]
  belongs_to :client

  validates :number_of_beds, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :check_in_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }
  validates :eviction_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }

  def period
    if (eviction_date - check_in_date) / 86_400 < 1
      errors.add(:date, 'incorrect period')
    else
      self.residence_time = ActiveSupport::Duration.build(eviction_date - check_in_date).iso8601
    end
  end

end
