class Bill < ApplicationRecord
  enum status: %i[pending paid canceled]
  belongs_to :client
end
