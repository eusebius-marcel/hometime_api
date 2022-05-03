class Guest < ApplicationRecord
  validates :email, uniqueness: true
end
