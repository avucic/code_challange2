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
  belongs_to :merchant

  # force subclasses to be used for transaction creation
  validates :type, presence: true

  enum status: { pending: 0, processed: 1, error: 2 }

  before_create :generate_uuid

  def name
    @name ||= type.underscore&.gsub(/_transaction$/, '')&.to_sym
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
