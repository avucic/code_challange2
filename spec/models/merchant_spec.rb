# frozen_string_literal: true

# == Schema Information
#
# Table name: merchants
#
#  id                    :integer          not null, primary key
#  name                  :string
#  email                 :string
#  status                :boolean          default(FALSE)
#  total_transaction_sum :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  subject(:model) { described_class.new }

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
end
