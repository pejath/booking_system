class Request < ApplicationRecord
  before_create :set_residence_time

  enum apartment_class: %i[A B C Luxe]
  enum status: %i[pending in_progress approved canceled]
  belongs_to :user
  has_one :bill

  validate :check_residence_time
  validates :number_of_beds, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :check_in_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }
  validates :eviction_date, presence: true # , format: { with: /\A\d{0,4}-\d{0,2}-\d{0,2} \d{0,2}:\d{0,2}\z/i }

  def apartment_class=(value)
    super
  rescue ArgumentError
    @attributes.write_cast_value('apartment_class', value)
  end

  def status=(value)
    super
  rescue ArgumentError
    @attributes.write_cast_value('status', value)
  end

  private

  def check_residence_time
    return if eviction_date.nil? || check_in_date.nil?
    return unless (eviction_date - check_in_date) / 86_400 < 1

    errors.add(:residence_time, 'incorrect period')
  end

  def set_residence_time
    self.residence_time = ActiveSupport::Duration.build(eviction_date - check_in_date).iso8601
  end


end
