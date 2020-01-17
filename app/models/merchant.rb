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

class Merchant < ApplicationRecord
  validates :name, :email, presence: true
  # NOTE for testing purspose, I'm using this simple regext
  # For more robust validation, I would use something like: gem valid_email2
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }, uniqueness: true
end
