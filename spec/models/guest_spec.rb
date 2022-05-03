# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
