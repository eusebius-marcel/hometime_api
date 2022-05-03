# frozen_string_literal: true

module GemExtensions
  module HashValidator
    # DateValidator adds date validation to hash validator
    class DateValidator < ::HashValidator::Validator::Base
      DATE_FORMAT = '%Y-%m-%d'
      DATE_EXAMPLE = '2021-04-14'

      def initialize
        super('date')
      end

      def validate(key, value, _validations, errors)
        return errors[key] = presence_error_message unless value.is_a?(String)

        DateTime.strptime(value, DATE_FORMAT)
      rescue Date::Error
        errors[key] = presence_error_message
      end

      def presence_error_message
        "Date required, format: #{DATE_FORMAT}, e.g. #{DATE_EXAMPLE}"
      end
    end
  end
end
