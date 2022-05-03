# frozen_string_literal: true

# SaveReservationService takes reservation as an input and saves it
class SaveReservationService
  def initialize(reservation)
    @reservation = reservation
    @guest = reservation.guest
  end

  def execute
    guest = Guest.find_or_initialize_by(email: guest_attributes['email'])
    guest.attributes = guest_attributes
    guest.save!

    reservation = Reservation.find_or_initialize_by(code: reservation_attributes['code'])
    reservation.attributes = reservation_attributes.merge(guest_id: guest.id)
    reservation.save!

    reservation
  end

  private

  def guest_attributes
    @guest.attributes.except('id', 'created_at', 'updated_at')
  end

  def reservation_attributes
    @reservation.attributes.except('id', 'created_at', 'updated_at')
  end
end
