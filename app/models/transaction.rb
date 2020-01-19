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

class Transaction < ApplicationRecord
  include Transactionable

  belongs_to :merchant

  allow_transaction_types :initial, :refund, :settlement, :invalidation

  enum status: { pending: 0, processed: 1, error: 2 }

  scope :outdated, -> { where('created_at <= ?', 1.hour.ago) }

  before_create :generate_uuid
  after_create :update_merchant_total_transaction_sum

  # TODO: not sure about bussunies logic whether the change is allowed
  after_update :update_merchant_total_transaction_sum, if: :amount_changed?

  def name
    @name ||= type.underscore&.gsub(/_transaction$/, '')&.to_sym
  end

  private

  def update_merchant_total_transaction_sum
    merchant.update_total_transaction_sum
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
