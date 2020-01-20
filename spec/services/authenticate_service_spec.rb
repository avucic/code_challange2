# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticateService do
  describe '#call' do
    let(:merchant) { build(:merchant)         }
    let(:token)    { generate_token(merchant) }

    context 'when valid credentials' do
      subject(:context) { described_class.call(token: token) }

      before do
        allow(Merchant).to receive(:active).and_return(Merchant)
        allow(Merchant).to receive(:find).with(merchant.id).and_return(merchant)
      end

      it { expect(context.merchant).to eq merchant }
    end

    context 'when invalid credentials' do
      subject(:context) { described_class.call(token: 'invalid') }

      before { allow(Merchant).to receive(:find_by) }

      it { is_expected.to be_failure }

      it { expect(context.error).to eq 'Invalid authentication' }

      it { expect(context.merchant).to be_nil }
    end
  end
end
