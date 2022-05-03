# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    first_name { 'John' }
    last_name  { 'Doe' }
    email { 'guest@example.com' }
    phone_numbers { %w[62812345678 6812345679] }
  end
end
