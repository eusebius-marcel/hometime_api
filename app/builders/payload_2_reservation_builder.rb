# frozen_string_literal: true

# Payload2ReservationBuilder takes reservation payload 2 and build it into reservation
class Payload2ReservationBuilder
  PAYLOAD_FORMAT = {
    reservation: {
      code: 'string',
      start_date: 'date',
      end_date: 'date',
      expected_payout_amount: 'string',
      guest_details: {
        localized_description: 'string',
        number_of_adults: 'integer',
        number_of_children: 'integer',
        number_of_infants: 'integer'
      },
      guest_email: 'string',
      guest_first_name: 'string',
      guest_last_name: 'string',
      guest_phone_numbers: HashValidator.many('string'),
      listing_security_price_accurate: 'string',
      host_currency: 'string',
      nights: 'integer',
      number_of_guests: 'integer',
      status_type: 'string',
      total_paid_amount_accurate: 'string'
    }
  }.freeze

  attr_reader :errors
  def initialize(payload)
    validator = HashValidator.validate(payload, PAYLOAD_FORMAT)
    @errors = validator.errors
    @payload = payload[:reservation]
  end

  def build
    return if errors.present?

    Reservation.new(
      guest: guest,
      code: payload[:code],
      start_date: payload[:start_date],
      end_date: payload[:end_date],
      nights: payload[:nights],
      guests: payload[:number_of_guests],
      adults: guest_details[:number_of_adults],
      children: guest_details[:number_of_children],
      infants: guest_details[:number_of_infants],
      status: payload[:status_type],
      currency: payload[:host_currency],
      payout_price: payload[:expected_payout_amount],
      security_price: payload[:listing_security_price_accurate],
      total_price: payload[:total_paid_amount_accurate]
    )
  end

  private

  attr_reader :payload

  def guest
    Guest.new(
      first_name: payload[:guest_first_name],
      last_name: payload[:guest_last_name],
      email: payload[:guest_email],
      phone_numbers: payload[:guest_phone_numbers]
    )
  end

  def guest_details
    payload[:guest_details]
  end
end
