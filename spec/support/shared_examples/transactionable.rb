# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'transactions owner' do
  describe '#acts_as_transactions_owner' do
    let(:model)    { described_class.new      }
    let(:merchant) { build_stubbed(:merchant) }

    context 'with transactions association' do
      it { is_expected.to have_many(:transactions).dependent(:destroy) }
    end

    describe '#last_transaction' do
      before do
        allow(model).to receive(:transactions).and_return(['transaction'])
      end

      it { expect(model.last_transaction).to eq('transaction') }
    end
  end
end

RSpec.shared_examples 'transactionable' do
  describe '#allow_transaction_types' do
    let(:model) { described_class.new }

    it { is_expected.to validate_presence_of(:type) }

    context 'with scopes' do
      subject { described_class }

      it { is_expected.to respond_to(:initial) }
      it { is_expected.to respond_to(:invalidation) }
      it { is_expected.to respond_to(:refund) }
      it { is_expected.to respond_to(:settlement) }
    end
  end

  describe '#build_type_of' do
    context 'with initial type' do
      subject(:transaction) { described_class.build_type_of :initial, merchant, 100 }

      it { is_expected.to be_a_kind_of InitialTransaction }

      it { expect(transaction.amount).to eq 100.0 }
    end

    context 'with refund type' do
      subject(:model) { described_class.build_type_of :refund, merchant, 100 }

      it { is_expected.to be_a_kind_of RefundTransaction }
    end
  end

  describe '#create_type_of' do
    let(:transaction) { instance_double('Transaction', save: true) }

    before do
      allow(Transaction).to receive(:new).and_return(transaction)
      described_class.create_type_of :initial, merchant, 100
    end

    it { expect(transaction).to have_received(:save) }
  end
end
