# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reservation Request', type: :request do
  describe 'POST #save' do
    let(:payload_1) do
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

    let(:payload_2) do
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

    let(:expected_response_body) do
      {
        id: Integer,
        guest_id: Integer,
        code: reservation_code,
        start_date: DateTime.strptime(start_date, '%Y-%m-%d'),
        end_date: DateTime.strptime(end_date, '%Y-%m-%d'),
        nights: nights,
        guests: guests,
        adults: adults,
        children: children,
        infants: infants,
        status: status,
        currency: currency,
        payout_price: payout_price.to_f,
        security_price: security_price.to_f,
        total_price: total_price.to_f,
        created_at: satisfy { |v| DateTime.parse(v) },
        updated_at: satisfy { |v| DateTime.parse(v) },
        guest: match(
          {
            id: Integer,
            first_name: first_name,
            last_name: last_name,
            email: email,
            phone_numbers: [phone],
            created_at: satisfy { |v| DateTime.parse(v) },
            updated_at: satisfy { |v| DateTime.parse(v) }
          }.stringify_keys
        )
      }.stringify_keys
    end

    context 'with payload format 1' do
      before do
        post '/reservations', params: payload_1, as: :json
      end

      it 'returns http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected response body' do
        hash_body = JSON.parse(response.body)
        expect(hash_body).to match(expected_response_body)
      end
    end

    context 'with payload format 2' do
      before do
        post '/reservations', params: payload_2, as: :json
      end

      it 'returns http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected response body' do
        hash_body = JSON.parse(response.body)
        expect(hash_body).to match(expected_response_body)
      end
    end
  end
end
