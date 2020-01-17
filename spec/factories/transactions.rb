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

FactoryBot.define do
  factory(:transaction) do
    trait :initial do
      type { 'InitialTransaction' }
    end

    trait :invalidation do
      type { 'InvalidationTransaction' }
    end

    trait :invalidation do
      type { 'RefundTransaction' }
    end

    trait :settlement do
      type { 'SettlementTransaction' }
    end

    trait :refund do
      type { 'RefundTransaction' }
    end
  end
end
