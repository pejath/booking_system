class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[User Admin]

  has_many :requests
  has_many :bills, through: :requests

  validates :birthdate, allow_nil: true, format: { with: /\A\d{0,4}.\d{0,2}.\d{0,2}\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
