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
end
