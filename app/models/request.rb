class Request < ApplicationRecord
  before_create :period

  enum apartment_class: %i[A B C Luxe]
  enum status: %i[pending in_progress approved canceled]
  belongs_to :client
  has_one :bill

  validate :check_residence_time
  validates :number_of_beds, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :check_in_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }
  validates :eviction_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }

  private

  def check_residence_time
    return if eviction_date.nil? || check_in_date.nil?
    return unless (eviction_date - check_in_date) / 86_400 < 1

    errors.add(:residence_time, 'incorrect period')
  end

  def period
    self.residence_time = ActiveSupport::Duration.build(eviction_date - check_in_date).iso8601
  end

end
