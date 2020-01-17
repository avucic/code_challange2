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
    it { is_expected.to validate_presence_of(:type) }
  end
end
