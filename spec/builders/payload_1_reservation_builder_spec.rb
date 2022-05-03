# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payload1ReservationBuilder do
  let(:invalid_payload) do
    {
      reservation: {
        code: reservation_code,
        start_date: start_date,
        end_date: end_date,
        expected_payout_amount: payout_price,
        guest_details: {
          localized_description: "#{guests} guests",
          number_of_adults: adults,
          number_of_children: children,
          number_of_infants: infants
        },
        guest_email: email,
        guest_first_name: first_name,
        guest_last_name: last_name,
        guest_phone_numbers: [phone],
        listing_security_price_accurate: security_price,
        host_currency: currency,
        nights: nights,
        number_of_guests: guests,
        status_type: status,
        total_paid_amount_accurate: total_price
      }
    }
  end
  let(:valid_payload) do
    {
      reservation_code: reservation_code,
      start_date: start_date,
      end_date: end_date,
      nights: nights,
      guests: guests,
      adults: adults,
      children: children,
      infants: infants,
      status: status,
      guest: {
        first_name: first_name,
        last_name: last_name,
        phone: phone,
        email: email
      },
      currency: currency,
      payout_price: payout_price,
      security_price: security_price,
      total_price: total_price
    }
  end
  let(:reservation_code) { 'YYY12345678' }
  let(:start_date) { '2021-04-14' }
  let(:end_date) { '2021-04-18' }
  let(:nights) { 4 }
  let(:guests) { 3 }
  let(:adults) { 2 }
  let(:children) { 1 }
  let(:infants) { 0 }
  let(:status) { 'accepted' }
  let(:first_name) { 'Wayne' }
  let(:last_name) { 'Woodbridge' }
  let(:phone) { '639123456789' }
  let(:email) { 'wayne_woodbridge@bnb.com' }
  let(:currency) { 'AUD' }
  let(:payout_price) { '4200.00' }
  let(:security_price) { '500' }
  let(:total_price) { '4700.00' }

  describe '#build' do
    context 'with valid payload format' do
      subject(:reservation) { described_class.new(valid_payload).build }

      it 'returns a reservation' do
        expect(reservation).to be_a Reservation
      end

      it 'returns reservation with expected attributes' do
        expect(reservation).to be_a Reservation

        expect(reservation.code).to eq reservation_code
        expect(reservation.start_date).to eq DateTime.strptime(start_date, '%Y-%m-%d')
        expect(reservation.end_date).to eq DateTime.strptime(end_date, '%Y-%m-%d')
        expect(reservation.nights).to eq nights
        expect(reservation.guests).to eq guests
        expect(reservation.adults).to eq adults
        expect(reservation.children).to eq children
        expect(reservation.infants).to eq infants
        expect(reservation.status).to eq status
        expect(reservation.currency).to eq currency
        expect(reservation.payout_price).to eq payout_price.to_f
        expect(reservation.security_price).to eq security_price.to_f
        expect(reservation.total_price).to eq total_price.to_f
      end

      it 'returns reservation with expected guest attributes' do
        guest = reservation.guest

        expect(guest.first_name).to eq first_name
        expect(guest.last_name).to eq last_name
        expect(guest.email).to eq email
        expect(guest.phone_numbers).to eq [phone]
      end
    end

    context 'with invalid payload format' do
      subject(:reservation) { described_class.new(invalid_payload).build }

      it 'returns nil' do
        expect(reservation).to be_nil
      end
    end
  end

  describe '#errors' do
    context 'with valid payload format' do
      subject(:builder) { described_class.new(valid_payload) }

      it 'returns blank' do
        builder.build

        expect(builder.errors).to be_blank
      end
    end

    context 'with invalid payload format' do
      subject(:builder) { described_class.new(invalid_payload) }

      it 'returns error' do
        builder.build

        expect(builder.errors).to be_present
      end
    end
  end
end
