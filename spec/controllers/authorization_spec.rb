# frozen_string_literal: true

require 'rails_helper'

describe ApiController, type: :controller do
  controller do
    def index
      authorize_api_request
      respond_with OpenStruct.new foo: 'foo'
    end
  end

  let(:json) { JSON.parse(response.body) }

  before { request.accept = 'application/json' }

  context 'when merchant is authorized' do
    let(:merchant) { build_stubbed(:merchant) }

    before do
      allow(AuthorizeApiRequestService).to receive(:call).and_return(OpenStruct.new(merchant: merchant))
      get :index
    end

    it { expect(json['foo']).to eq 'foo' }
  end

  context 'with unauthorized request' do
    before { get :index }

    it { expect(json['errors'].first).to eq 'Unauthorized' }
  end
end
