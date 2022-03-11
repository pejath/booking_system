class Client < ApplicationRecord
  has_many :requests
  has_many :bills

  validates :name, presence: true
  validates :surname, presence: true
  validates :birthdate, presence: true, format: { with: /\A\d{0,4}.\d{0,2}.\d{0,2}\z/ }
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
