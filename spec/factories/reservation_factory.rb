# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    association :guest
    code { 'RESERVATION_CODE' }
    start_date { Date.today }
    end_date { Date.tomorrow }
    nights { 1 }
    guests { 9 }
    adults { 2 }
    children { 3 }
    infants { 4 }
    status { 'pending' }
    currency { 'USD' }
    payout_price { 5000.00 }
    security_price { 500.00 }
    total_price { 5500.00 }
  end
end
