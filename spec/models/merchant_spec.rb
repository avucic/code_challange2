# frozen_string_literal: true

# == Schema Information
#
# Table name: merchants
#
#  id                    :integer          not null, primary key
#  name                  :string
#  email                 :string
#  status                :boolean          default(FALSE)
#  total_transaction_sum :float            default(0.0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  subject(:model) { described_class.new }

  it { is_expected.to have_many(:transactions).dependent(:destroy) }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }

    # email
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('foo@bar.com').for(:email) }
    it { is_expected.not_to allow_value('foo@barcom').for(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  context 'with default vallues' do
    it { expect(model.status).to be(false) }
  end

  describe '#scopes' do
    context 'with active scope' do
      subject(:sql) { described_class.active.to_sql }

      it { is_expected.to eq(described_class.unscoped.where(status: true).to_sql) }
    end

    context 'with inactive scope' do
      subject(:sql) { described_class.inactive.to_sql }

      it { is_expected.to eq(described_class.unscoped.where(status: false).to_sql) }
    end
  end

  describe '#update_total_transaction_sum' do
    let(:merchant)     { build_stubbed(:merchant)           }
    let(:transactions) { double('transactions', sum: 100.0) }

    before do
      allow(merchant).to receive(:transactions).and_return(transactions)
      allow(merchant).to receive(:update).with(total_transaction_sum: 100.0)

      merchant.update_total_transaction_sum
    end

    it { expect(merchant).to have_received(:update) }
  end

  it_behaves_like 'transactions owner'
end
