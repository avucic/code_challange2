# frozen_string_literal: true

require 'rails_helper'

describe JsonWebToken do
  let(:token) { described_class.encode(merchant_id: 1) }

  context 'with valid token' do
    it { expect(described_class.decode(token)[:merchant_id]) .to eq 1 }
  end

  context 'with invalid token' do
    it { expect { described_class.decode('invalid') } .to raise_error('Invalid token') }
  end
end
