# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionFlowValidator do
  subject(:model) { TransactionModel.new merchant: merchant }

  let(:transaction_one)   { instance_double('Transaction', name: :transaction_one)       }
  let(:transaction_two)   { instance_double('Transaction', name: :transaction_two)       }
  let(:transaction_three) { instance_double('Transaction', name: :transaction_three)     }

  describe 'from: :none' do
    with_model :TransactionModel do
      model do
        attribute :merchant
        validates_with TransactionFlowValidator, from: :none

        def name
          :transaction_model
        end
      end
    end

    context 'when previous transaction does not exits' do
      let(:merchant) { instance_double('Merchant', transactions: []) }

      it { is_expected.to have(0).error_on(:base) }
    end

    context 'when previous transaction exists' do
      let(:merchant) { instance_double('Merchant', transactions: [transaction_one]) }

      before { model.valid? }

      it { is_expected.to have(1).error_on(:base) }

      it 'returns error message' do
        expect(model.errors[:base].first).to eq(
          'Invalid transaction flow. Transaction from TransactionModel to TransactionOne is not posibble!'
        )
      end
    end
  end

  describe 'from: multiple previous transactions' do
    with_model :TransactionModel do
      model do
        attribute :merchant
        validates_with TransactionFlowValidator, from: %i[transaction_one transaction_two]

        def name
          :transaction_model
        end
      end
    end

    context 'when last transaction is included' do
      let(:merchant) { instance_double('Merchant', transactions: [transaction_two]) }

      it { is_expected.to have(0).error_on(:base) }
    end

    context 'when last transaction is not included' do
      let(:merchant) { instance_double('Merchant', transactions: [transaction_three]) }

      before { model.valid? }

      it { is_expected.to have(1).error_on(:base) }

      it 'returns error message' do
        expect(model.errors[:base].first).to eq(
          'Invalid transaction flow. Transaction from TransactionModel to TransactionThree is not posibble!'
        )
      end
    end
  end
end
