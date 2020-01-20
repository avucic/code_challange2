# frozen_string_literal: true

class AuthorizeApiRequestService < AuthenticateService
  def call
    context.merchant = authenticate_merchant_from_token
  end

  private

  def headers
    @headers ||= context.headers || {}
  end

  def authenticate_merchant_from_token
    context.token = http_auth_token
    merchant
  end

  def http_auth_token
    return headers['Authorization'].split(' ').last if
      headers['Authorization'].present?

    context.error = 'Invalid token'
    context.fail!
  end
end
