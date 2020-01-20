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

class Merchant < ApplicationRecord
  include Transactionable
  include RoleModel

  roles :admin, :merchant
  acts_as_transactions_owner

  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }

  validates :name, :email, presence: true
  # NOTE for testing purspose, I'm using this simple regext
  # For more robust validation, I would use something like: gem valid_email2
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }, uniqueness: true

  before_create :set_default_role

  def update_total_transaction_sum
    update(total_transaction_sum: transactions.sum(:amount))
  end

  def mark_as_inactive!
    update(status: false)
  end

  private

  def set_default_role
    roles << :merchant
  end
end
