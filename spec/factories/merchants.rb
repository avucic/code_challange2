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

FactoryBot.define do
  factory(:merchant) do
    email { Faker::Internet.email.gsub(/@.*$/, '@emerchantpaym.com') }
    name { Faker::Name.name }
    trait :active do
      status { true }
    end
  end
end
