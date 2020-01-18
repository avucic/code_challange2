# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  type        :string
#  merchant_id :integer          not null
#  uuid        :string           not null
#  amount      :float
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe InitialTransaction, type: :model do
  subject(:model) { described_class.new merchant: merchant }

  describe 'Validations' do
    context 'without previous transactions' do
      let(:merchant) { build_stubbed(:merchant) }

      it { is_expected.to have(0).error_on(:base) }
    end

    context 'with previous is initial transactions' do
      let(:invalidation_transaction) { build_stubbed(:transaction, :invalidation) }
      let(:merchant) { build_stubbed(:merchant, transactions: [invalidation_transaction]) }

      it { is_expected.to have(0).error_on(:base) }
    end

    context 'with previous is settlement transactions' do
      let(:settlement_transaction) { build_stubbed(:transaction, :settlement) }
      let(:merchant) { build_stubbed(:merchant, transactions: [settlement_transaction]) }

      it { is_expected.to have(0).error_on(:base) }
    end

    context 'with previous unsupported transaction' do
      let(:not_supported_transaction) { build_stubbed(:transaction, :refund) }
      let(:merchant) { build_stubbed(:merchant, transactions: [not_supported_transaction]) }

      it { is_expected.to have(1).error_on(:base) }
    end
  end
end
