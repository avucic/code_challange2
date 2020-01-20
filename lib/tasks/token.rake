# frozen_string_literal: true

namespace :api do
  desc 'Generate API jwt token using email'
  task :token, [:email] => :environment do |_t, args|
    raise ArgumentError, 'Missing merchant email' unless args[:email]

    merchant = Merchant.find_by!(email: args[:email])
    puts
    puts
    puts JsonWebToken.encode(merchant_id: merchant.id)
    puts
  end
end
