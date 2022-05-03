# frozen_string_literal: true

# Payload1ReservationBuilder takes reservation payload 1 and build it into reservation
class Payload1ReservationBuilder
  PAYLOAD_FORMAT = {
    reservation_code: 'string',
    start_date: 'date',
    end_date: 'date',
    nights: 'integer',
    guests: 'integer',
    adults: 'integer',
    children: 'integer',
    infants: 'integer',
    status: 'string',
    guest: {
      first_name: 'string',
      last_name: 'string',
      phone: 'string',
      email: 'string'
    },
    currency: 'string',
    payout_price: 'string',
    security_price: 'string',
    total_price: 'string'
  }.freeze

  attr_reader :errors
  def initialize(payload)
    validator = HashValidator.validate(payload, PAYLOAD_FORMAT)
    @errors = validator.errors
    @payload = payload
  end

  def build
    return if errors.present?

    Reservation.new(
      guest: guest,
      code: payload[:reservation_code],
      start_date: payload[:start_date],
      end_date: payload[:end_date],
      nights: payload[:nights],
      guests: payload[:guests],
      adults: payload[:adults],
      children: payload[:children],
      infants: payload[:infants],
      status: payload[:status],
      currency: payload[:currency],
      payout_price: payload[:payout_price],
      security_price: payload[:security_price],
      total_price: payload[:total_price]
    )
  end

  private

  attr_reader :payload

  def guest
    Guest.new(
      first_name: guest_payload[:first_name],
      last_name: guest_payload[:last_name],
      email: guest_payload[:email],
      phone_numbers: [guest_payload[:phone]]
    )
  end

  def guest_payload
    payload[:guest]
  end
end
