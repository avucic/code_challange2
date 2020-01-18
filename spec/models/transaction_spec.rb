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

  it_behaves_like 'transactionable'
end
