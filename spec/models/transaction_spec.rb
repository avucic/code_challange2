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

RSpec.describe Transaction, type: :model do
  subject(:transaction) { build_stubbed(:transaction, merchant: merchant) }

  let(:merchant) { build_stubbed(:merchant) }

  before { allow(merchant).to receive(:update_total_transaction_sum) }

  it { is_expected.to belong_to(:merchant) }

  context 'with validations' do
    it do
      expect(transaction).to define_enum_for(:status).with_values(
        pending: 0, processed: 1, error: 2
      )
    end
  end

  context 'with defaults' do
    it 'generates uuid' do
      expect { transaction.run_callbacks :create }.to change(transaction, :uuid)
    end
  end

  describe '#name' do
    subject(:transaction) { build(:transaction, type: 'FooTransaction') }

    it 'generate name based on the type value' do
      expect(transaction.name).to eq :foo
    end
  end

  describe 'merchant#total_transaction_sum' do
    context 'when transaction is created' do
      let(:merchant) { build_stubbed(:merchant) }
      let(:transaction) { build_stubbed(:transaction, merchant: merchant) }

      before do
        transaction.run_callbacks(:create)
      end

      it 'updates merchant total_transaction_sum' do
        expect(merchant).to have_received(:update_total_transaction_sum)
      end
    end

    context 'when transaction amount is updated' do
      let(:merchant) { build_stubbed(:merchant) }
      let(:transaction) { build_stubbed(:transaction, amount: 100, merchant: merchant) }

      before do
        transaction.amount = 200.0
        transaction.run_callbacks(:update)
      end

      it 'updates merchant total_transaction_sum' do
        expect(merchant).to have_received(:update_total_transaction_sum)
      end
    end

    context 'when transaction amount is not updated' do
      let(:merchant) { build_stubbed(:merchant) }
      let(:transaction) { build_stubbed(:transaction, amount: 100, merchant: merchant) }

      before do
        transaction.run_callbacks(:update)
      end

      it 'updates merchant total_transaction_sum' do
        expect(merchant).not_to have_received(:update_total_transaction_sum)
      end
    end
  end

  it_behaves_like 'transactionable'
end
