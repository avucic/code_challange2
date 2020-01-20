# frozen_string_literal: true

class AuthenticateService < ApplicationService
  def call
    context.merchant = merchant
  end

  private

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(context.token)
  end

  def merchant
    id = decoded_auth_token[:merchant_id]
    Merchant.find(id)
  rescue StandardError => e
    context.error = 'Invalid authentication'
    context.fail!
  end
end
