# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it { should belong_to(:guest) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:code).case_insensitive }
  end
end
