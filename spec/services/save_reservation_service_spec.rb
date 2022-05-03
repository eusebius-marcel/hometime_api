# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveReservationService do
  describe '#execute' do
    shared_examples 'create_new_reservation' do
      it 'creates new reservation' do
        expect { service.execute }.to change { Reservation.count }.by 1
      end
    end

    shared_examples 'create_new_guest' do
      it 'creates new guest' do
        expect { service.execute }.to change { Guest.count }.by 1
      end
    end

    shared_examples 'update_existing_reservation' do
      it 'does not create new reservation' do
        expect { service.execute }.not_to(change { Reservation.count })
      end

      it 'updates existing reservation' do
        expect { service.execute }.to(
          change { existing_reservation.reload.start_date }
          .and(change { existing_reservation.reload.end_date })
          .and(change { existing_reservation.reload.nights })
          .and(change { existing_reservation.reload.guests })
          .and(change { existing_reservation.reload.adults })
          .and(change { existing_reservation.reload.children })
          .and(change { existing_reservation.reload.infants })
          .and(change { existing_reservation.reload.status })
          .and(change { existing_reservation.reload.currency })
          .and(change { existing_reservation.reload.payout_price })
          .and(change { existing_reservation.reload.security_price })
          .and(change { existing_reservation.reload.total_price })
        )
      end
    end

    shared_examples 'update_existing_guest' do
      it 'does not create new guest' do
        expect { service.execute }.not_to(change { Guest.count })
      end

      it 'updates existing guest' do
        expect { service.execute }.to(
          change { existing_guest.reload.first_name }
          .and(change { existing_guest.reload.last_name })
          .and(change { existing_guest.reload.phone_numbers })
        )
      end
    end

    context 'with new reservation code' do
      subject(:service) { SaveReservationService.new(reservation) }

      context 'with new guest email' do
        let(:reservation) { create :reservation }

        include_examples 'create_new_reservation'
        include_examples 'create_new_guest'
      end

      context 'with existing guest email' do
        let!(:existing_guest) { create :guest }

        let(:reservation) { create :reservation, guest: updated_guest }
        let(:updated_guest) do
          build :guest, first_name: 'Wayne', last_name: 'Woodbridge', phone_numbers: %w[639123456789 639123456780]
        end

        include_examples 'create_new_reservation'
        include_examples 'update_existing_guest'
      end
    end

    context 'with existing reservation code' do
      subject(:service) { SaveReservationService.new(updated_reservation) }

      let!(:existing_reservation) { create :reservation }

      let(:updated_reservation) do
        build :reservation,
              guest: guest,
              start_date: Date.yesterday,
              end_date: Date.today,
              nights: 2,
              guests: 4,
              adults: 3,
              children: 1,
              infants: 0,
              status: 'accepted',
              currency: 'AUD',
              payout_price: 4000.00,
              security_price: 250.00,
              total_price: 4250.00
      end

      context 'with new guest email' do
        let(:guest) { new_guest }
        let(:new_guest) do
          build :guest, email: 'new_guest@example.com'
        end
        include_examples 'update_existing_reservation'
        include_examples 'create_new_guest'
      end

      context 'when existing guest email' do
        let!(:existing_guest) { existing_reservation.guest }

        let(:guest) { updated_guest }
        let(:updated_guest) do
          build :guest, first_name: 'Wayne', last_name: 'Woodbridge', phone_numbers: %w[639123456789 639123456780]
        end

        include_examples 'update_existing_reservation'
        include_examples 'update_existing_guest'
      end
    end
  end
end
