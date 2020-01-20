# frozen_string_literal: true

require 'rails_helper'

require 'rails_helper'
RSpec.describe Api::V1::TransactionsController do
  let(:merchant)       { create(:merchant)                                    }
  let(:valid_params)   { { transaction: { amount: 100.0 } }                   }
  let(:invalid_params) { { transaction: { amount: 100.0, type: :refund } }    }

  before { sing_in(merchant) }

  describe 'POST JSON #create' do
    let(:json) { JSON.parse(response.body) }

    context 'with valid request' do
      before do
        post '/api/v1/transactions.json', params: valid_params
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it { expect(json['amount']).to eq 100.0 }

      it { expect(json['type']).to eq 'initial' }

      it 'JSON body response contains expected attributes' do
        expect(json.keys).to match_array(%w[amount type])
      end
    end

    context 'with invalid request' do
      before do
        post '/api/v1/transactions.json', params: invalid_params
      end

      it 'returns http success' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it { expect(json['errors'].first).to match(/Invalid transaction flow/) }
    end
  end

  describe 'POST XML #create' do
    let(:xml) { Hash.from_xml(response.body)['hash'] }

    context 'with valid request' do
      before do
        post '/api/v1/transactions.xml', params: valid_params
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it { expect(xml['amount']).to eq 100.0 }

      it { expect(xml['type']).to eq 'initial' }

      it 'XML body response contains expected attributes' do
        expect(xml.keys).to match_array(%w[amount type])
      end
    end

    context 'with invalid request' do
      before do
        post '/api/v1/transactions.xml', params: invalid_params
      end

      it 'returns http success' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it { expect(xml['errors'].first).to match(/Invalid transaction flow/) }
    end
  end
end
