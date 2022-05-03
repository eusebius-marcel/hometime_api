class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, uniqueness: true
end
