# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizeApiRequestService do
  let(:merchant)       { build_stubbed(:merchant)                          }
  let(:valid_token)    { generate_token(merchant)                          }
  let(:invalid_token)  { 'invalid'                                         }
  let(:expired_token)  { generate_token(merchant, Time.zone.now - 10.days) }
  let(:header)         { { Authorization: token }.stringify_keys           }

  describe 'valid authorization' do
    subject(:context) { described_class.call(headers: header) }

    let(:token) { valid_token }

    before do
      allow(Merchant).to receive(:active).and_return(Merchant)
      allow(Merchant).to receive(:find).with(merchant.id).and_return(merchant)
    end

    it 'returns merchant object' do
      expect(context.merchant).to eq(merchant)
    end
  end

  describe 'invalid authorization' do
    context 'when missing token' do
      subject(:error) { described_class.call({}).error }

      it { is_expected.to eq 'Invalid token' }
    end

    context 'when invalid token' do
      subject(:context) { described_class.call(header) }

      let(:token) { invalid_token }

      it { is_expected.to be_failure }

      it { expect(context.error).to eq 'Invalid token' }
    end

    context 'when token is expired' do
      subject(:context) { described_class.call(header) }

      let(:token) { expired_token }

      it { is_expected.to be_failure }

      it { expect(context.error).to eq 'Invalid token' }
    end
  end
end
