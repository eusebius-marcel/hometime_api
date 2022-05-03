# frozen_string_literal: true

# ReservationBuilder takes reservation payload and build it into reservation
class ReservationBuilder
  RESERVATION_BUILDER_CLASSES = [Payload1ReservationBuilder, Payload2ReservationBuilder].freeze

  attr_reader :errors
  def initialize(payload)
    @payload = payload
    @reservation = nil
    @errors = nil
  end

  def build
    RESERVATION_BUILDER_CLASSES.each do |reservation_builder_class|
      reservation_builder = reservation_builder_class.new(payload)
      self.reservation = reservation_builder.build
      self.errors = reservation_builder.errors

      break if errors.blank?
    end

    reservation
  end

  private

  attr_reader :payload
  attr_writer :errors
  attr_accessor :reservation
end
