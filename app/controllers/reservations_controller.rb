class ReservationsController < ApplicationController
  # POST /reservations
  def save
    payload = params.to_unsafe_h
    payload_builder = Payload1ReservationBuilder.new(payload)
    reservation = payload_builder.build

    if payload_builder.errors.present?
      payload_builder = Payload2ReservationBuilder.new(payload)
      reservation = payload_builder.build
    end

    if payload_builder.errors.present?
      render json: { message: 'Unknown payload format' }, status: :unprocessable_entity
    else
      reservation = SaveReservationService.new(reservation).execute
      render json: reservation, include: :guest, status: :ok
    end
  end
end
