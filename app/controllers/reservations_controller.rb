class ReservationsController < ApplicationController
  # POST /reservations
  def save
    payload = params.to_unsafe_h
    reservation_builder = ReservationBuilder.new(payload)
    reservation = reservation_builder.build

    if reservation_builder.errors.present?
      render json: { message: 'Unknown payload format' }, status: :unprocessable_entity
    else
      reservation = SaveReservationService.new(reservation).execute
      render json: reservation, include: :guest, status: :ok
    end
  end
end
